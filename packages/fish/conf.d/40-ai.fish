# Anthropic API key for Neovim AI plugins (codecompanion, avante).
# Load it from 1Password only when an editor needs it. Fetching it during Fish
# startup makes every new terminal request 1Password authentication.
function load_ai_claude_api_key --description 'Load the Anthropic API key from 1Password'
    if set -q AI_CLAUDE_API_KEY
        return 0
    end
    if not type -q op
        return 1
    end

    set -l _key (op read 'op://Private/Anthropic API Key/credential' 2>/dev/null)
    if test -z "$_key"
        return 1
    end

    set -gx AI_CLAUDE_API_KEY $_key
end

if status is-interactive
    function __load_ai_claude_api_key_for_editor --on-event fish_preexec
        set -l _command_line $argv[1]
        if string match -rq '(^|[;&|[:space:]])(nvim|vim|vi)([[:space:]]|$)' -- $_command_line
            load_ai_claude_api_key
        end
    end
end
