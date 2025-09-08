function _ai_commit_full --description "Generate a full, well-structured commit message"
    _ai_diff_slice | read -z DIFF; or return 1

    set -l fmt_rules "
Write a Conventional Commit message with:
- 1 subject line (≤72 chars, type + optional scope, imperative).
- Blank line.
- A concise body (~72 cols) explaining WHY, not just what.
- Bullet list of key changes if helpful.
- 'BREAKING CHANGE: …' footer if applicable.
No emojis. No code fences. Output ONLY the message."

    switch (_ai_commit_provider)
        case ollama
            set -l model (set -q OLLAMA_MODEL; and echo $OLLAMA_MODEL; or echo "llama3.1:8b")
            ollama run $model "$fmt_rules

Diff:
$DIFF" 2>/dev/null | string trim
        case openai
            set -l model (set -q OPENAI_MODEL; and echo $OPENAI_MODEL; or echo o4-mini)
            set -l sys "You are a rigorous code reviewer who writes high-quality Conventional Commit messages."
            set -l usr "$fmt_rules

Diff:
$DIFF"
            set -l payload (jq -n --arg model "$model" --arg sys "$sys" --arg usr "$usr" '
              {
                model:$model,
                input:[
                  {"role":"system","content":[{"type":"input_text","text":$sys}]},
                  {"role":"user","content":[{"type":"input_text","text":$usr}]}
                ],
                temperature:0.2, max_output_tokens:512
              }')
            curl -sS --connect-timeout 2 --max-time 6 https://api.openai.com/v1/responses \
              -H "Authorization: Bearer $OPENAI_API_KEY" \
              -H "Content-Type: application/json" \
              -d "$payload" \
            | jq -r '.output_text' | string trim
        case '*'
            echo "(stage changes, install ollama or set OPENAI_API_KEY)" >&2
            return 1
    end
end
