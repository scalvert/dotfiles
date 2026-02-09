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

# Cloud SDK Python paths (if scio environment exists)
if set -q SCIO_ROOT; and test -f "$SCIO_ROOT/python_scio/scio_env/bin/python"
    set -gx CLOUDSDK_GSUTIL_PYTHON "$SCIO_ROOT/python_scio/scio_env/bin/python"
    set -gx CLOUDSDK_BQ_PYTHON "$SCIO_ROOT/python_scio/scio_env/bin/python"
    set -gx CLOUDSDK_PYTHON "$SCIO_ROOT/python_scio/scio_env/bin/python"
end

# GPG Agent
if command -v gpgconf >/dev/null
    gpgconf --launch gpg-agent 2>/dev/null
end

# fzf key bindings (if available)
if command -v fzf >/dev/null
    fzf --fish | source 2>/dev/null
end
