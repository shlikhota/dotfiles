function _ai_diff_slice --description "Return staged diff; shrink if huge"
    git diff --cached --quiet; and return 1

    set -l raw (git diff --cached -U50 --no-color | string collect)

    # Optional redaction (very basic)
    if set -q AI_COMMIT_REDACT
        set raw (echo $raw | \
            string replace -ra '([A-Za-z0-9_]*api[_-]?key[A-Za-z0-9_]*\s*[:=]\s*)\S+' '$1[REDACTED]' | \
            string replace -ra '(Authorization:\s*)\S+' '$1[REDACTED]' | string collect)
    end

    set -l max 80000
    if test (string length -- $raw) -gt $max
        set -l files (git diff --cached --name-status | string collect)
        set -l stats (git diff --cached --numstat | string collect)
        printf "FILES:\n%s\n\nNUMSTAT:\n%s\n" $files $stats
    else
        printf "%s" $raw
    end
end
