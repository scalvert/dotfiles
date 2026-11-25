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

# Employer-specific paths, cloud projects and account names belong in
# local.fish (see local.fish.template), not here. This repo is public.

set -l node_extra_ca_cert "$HOME/certificates/rootCA.pem"
if test -f $node_extra_ca_cert
    set -gx NODE_EXTRA_CA_CERTS $node_extra_ca_cert
end

# Homebrew completions
if test -d /opt/homebrew/share/fish/completions
    set -gx fish_complete_path /opt/homebrew/share/fish/completions $fish_complete_path
end
