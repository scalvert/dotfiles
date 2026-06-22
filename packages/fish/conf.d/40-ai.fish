# Anthropic API key for Neovim AI plugins (codecompanion, avante).
# Fetched from 1Password at interactive shell start — never stored on disk.
# Guarded so a locked or absent 1Password never breaks shell startup; if the
# key can't be read, AI_CLAUDE_API_KEY is simply unset and the plugins degrade.
if status is-interactive; and type -q op
    set -l _key (op read 'op://Private/Anthropic API Key/credential' 2>/dev/null)
    if test -n "$_key"
        set -gx AI_CLAUDE_API_KEY $_key
    end
end
