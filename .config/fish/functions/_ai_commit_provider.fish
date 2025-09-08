function _ai_commit_provider --description "Detect which AI provider to use"
    if set -q AI_COMMIT_PROVIDER
        echo $AI_COMMIT_PROVIDER; return
    end

    if set -q OPENAI_API_KEY
        echo openai
    else if type -q ollama
        echo ollama
    else
        echo none
    end
end
