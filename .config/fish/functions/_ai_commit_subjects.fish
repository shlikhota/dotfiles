function _ai_commit_subjects --description "Generate 5 subject-line suggestions from staged diff"
    _ai_diff_slice | read -z DIFF; or return 1

    set -l provider (_ai_commit_provider)
    set -l out
    set -l simple_prompt "Generate 5 git commit messages from this diff. Follow these rules:

    **Format**: `type: description` (max 50 chars)
    **Types**: feat, fix, docs, style, refactor, test, chore
    **Style**: Imperative mood (add/fix/update, not added/fixed/updated)

    **Examples**:
    - `feat: add user login validation`
    - `fix: resolve memory leak in parser`
    - `docs: update API documentation`

    **Output exactly like this**:
    1. [message]
    2. [message]
    3. [message]
    4. [message]
    5. [message]

    **Git Diff**:
    ```
    $DIFF
    ```"

    set -l complex_prompt " You are an expert developer who writes clear, concise git commit messages following conventional commit standards. Based on the provided git diff, generate exactly 5 different commit message suggestions.
    Requirements:
    - Output: EXACTLY 5 lines. No bullets, no numbering, no prose.
    - Length: Maximum 70 characters for the subject line
    - Format: Use conventional commit format: type(scope): description
    - Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build
    - Tone: Use imperative mood (e.g., 'add', 'fix', 'update', not 'added', 'fixed', 'updated')
    - Focus: Capture the most important change, not every detail
    - Clarity: Be specific enough that someone can understand the change without seeing the diff
    - Formatting: No trailing period. No emojis. No quotes.

    Output Format:
    [commit message 1]
    [commit message 2]
    [commit message 3]
    [commit message 4]
    [commit message 5]

    Analysis Guidelines:
    If multiple files changed, focus on the primary purpose of the change
    For bug fixes, mention what was broken if clear from context
    For new features, describe the capability added
    For refactoring, mention what was improved/reorganized
    For documentation, specify what docs were updated
    Prioritize user-facing changes over internal implementation details

    Git Diff:
    $DIFF"

    switch $provider
        case ollama
            set -l model (set -q OLLAMA_MODEL; and echo $OLLAMA_MODEL; or echo "qwen2.5-coder:7b")
            set -l num_ctx (set -q OLLAMA_NUM_CTX; and echo $OLLAMA_NUM_CTX; or echo "8192")
            set -l payload (jq -n --arg model "$model" --arg sys "" --arg usr "$simple_prompt" --argjson num_ctx $num_ctx '
              {
                model:$model,
                prompt:$usr,
                options:{num_ctx:$num_ctx},
                stream:false
              }')
            set out (curl -sS --connect-timeout 2 --max-time 30 http://localhost:11434/api/generate \
                -d "$payload" \
                | jq -r '.response' | string collect | string trim)
            # set out (ollama run "$model" "$simple_prompt" 2>/dev/null | string collect | string trim)
        case openai
            set -l model (set -q OPENAI_MODEL; and echo $OPENAI_MODEL; or echo gpt-4o-mini)
            set -l payload (jq -n --arg model "$model" --arg sys "" --arg usr "$complex_prompt" '
              {
                model:$model,
                input:$usr,
                temperature:0.2,
                max_output_tokens:256
              }')
            set out (curl -sS --connect-timeout 2 --max-time 10 https://api.openai.com/v1/responses \
              -H "Authorization: Bearer $OPENAI_API_KEY" \
              -H "Content-Type: application/json" \
              -d "$payload" \
              | jq -r '.output[] | select(.type == "message") | .content[0].text' | string collect | string trim)
          case '*'
            echo "(stage changes, install ollama (set OLLAMA_MODEL) or set OPENAI_API_KEY)" >&2
            return 1
    end

    # Sanitize and cap
    set -l lines
    for s in (string split \n -- $out)
        set s (string trim -- $s)
        test -n "$s"; or continue
        # Strip bullets/numbers if model cheated
        set s (string replace -r '^[\-\*\d\.\)\s]+' '' -- $s)
        set -a lines $s
    end

    set -l count (count $lines)
    if test $count -gt 5
        set lines $lines[1..5]
    end
    printf "%s\n" $lines
end
