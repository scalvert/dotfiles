# Environment Variables
# Non-secret environment configuration

# Editor settings
set -gx EDITOR nvim
set -gx VISUAL nvim

# Go
set -gx GOPATH $HOME/go

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"

# .NET
set -Ux DOTNET_ROOT /usr/local/share/dotnet

# GPG
set -gx GNUPGHOME ~/.gnupg
set -gx PINENTRY_USER_DATA "USE_KEYCHAIN=true"
set -gx GPG_TTY (tty)

# Java (use java_home if available on macOS)
switch (uname)
    case Darwin
        if test -x /usr/libexec/java_home
            set -gx JAVA_HOME (/usr/libexec/java_home -v17 2>/dev/null)
        end
end

# Workspace paths (customize these in local.fish if needed)
if test -d $HOME/workspace/scio
    set -gx SCIO_ROOT $HOME/workspace/scio
    set -gx DEVDOCK_ROOT $HOME/workspace/scio
    if not contains -- $HOME/workspace/scio $PATH
        set -gx PATH $HOME/workspace/scio $PATH
    end
end

set -l node_extra_ca_cert "$HOME/certificates/rootCA.pem"
if test -f $node_extra_ca_cert
    set -gx NODE_EXTRA_CA_CERTS $node_extra_ca_cert
end

# Claude/Vertex AI (non-secret config)
set -gx CLAUDE_CODE_USE_VERTEX 1
set -gx CLOUD_ML_REGION us-east5
set -gx ANTHROPIC_VERTEX_PROJECT_ID dev-sandbox-334901

# Homebrew completions
if test -d /opt/homebrew/share/fish/completions
    set -gx fish_complete_path /opt/homebrew/share/fish/completions $fish_complete_path
end
