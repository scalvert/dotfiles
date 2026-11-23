# Tool Integrations
# External tool initialization and hooks

# Starship prompt
if command -v starship >/dev/null
    starship init fish | source
end

# Homebrew
if test -f /opt/homebrew/share/fish/vendor_conf.d/homebrew.fish
    source /opt/homebrew/share/fish/vendor_conf.d/homebrew.fish
end

# mise (polyglot runtime manager)
if command -v mise >/dev/null
    mise activate fish | source
end

# direnv
if command -v direnv >/dev/null
    direnv hook fish | source
end

# zoxide (smart cd)
if command -v zoxide >/dev/null
    zoxide init fish | source
end

# atuin (shell history)
if command -v atuin >/dev/null
    atuin init fish | source
end

# Google Cloud SDK
set -l gcloud_path "$HOME/google-cloud-sdk/path.fish.inc"
if test -f $gcloud_path
    source $gcloud_path
end

# GPG Agent
if command -v gpgconf >/dev/null
    gpgconf --launch gpg-agent 2>/dev/null
end

# fzf key bindings (if available)
if command -v fzf >/dev/null
    fzf --fish | source 2>/dev/null
end

# GitHub CLI identity switching by directory. Each account has its own gh
# config directory. The work directory defaults to ~/.config/gh-work; set
# GH_WORK_CONFIG_DIR in local.fish to use another one.
function __gh_work_config_dir
    if set -q GH_WORK_CONFIG_DIR; and test -n "$GH_WORK_CONFIG_DIR"
        echo $GH_WORK_CONFIG_DIR
    else
        echo "$HOME/.config/gh-work"
    end
end

function __gh_set_config_dir --on-variable PWD
    if string match -q "$HOME/workspace/personal*" $PWD
        set -gx GH_CONFIG_DIR "$HOME/.config/gh-scalvert"
    else
        set -gx GH_CONFIG_DIR (__gh_work_config_dir)
    end
end
__gh_set_config_dir
