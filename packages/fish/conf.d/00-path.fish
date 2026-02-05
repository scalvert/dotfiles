# PATH Configuration
# Order matters: first in list = highest priority

# Helper function to add to path only if not already present
function __add_to_path --argument-names dir position
    if test -d $dir
        if not contains $dir $PATH
            if test "$position" = "prepend"
                set -gx PATH $dir $PATH
            else
                set -gx PATH $PATH $dir
            end
        end
    end
end

# Homebrew (highest priority for macOS)
switch (uname)
    case Darwin
        __add_to_path /opt/homebrew/bin prepend
        __add_to_path /opt/homebrew/sbin prepend
        __add_to_path /opt/homebrew/opt/gnu-getopt/bin prepend
end

# User local binaries
__add_to_path $HOME/.local/bin prepend
__add_to_path $HOME/bin prepend

# Cargo/Rust
__add_to_path $HOME/.cargo/bin

# Go
if set -q GOPATH
    __add_to_path $GOPATH/bin
else
    __add_to_path $HOME/go/bin
end

# pnpm
if set -q PNPM_HOME
    __add_to_path $PNPM_HOME
end

# .NET
__add_to_path /usr/local/share/dotnet
__add_to_path /opt/homebrew/share/dotnet

# Java
if set -q JAVA_HOME
    __add_to_path $JAVA_HOME/bin
end

# System paths (lower priority)
__add_to_path /usr/local/bin
__add_to_path /usr/local/sbin
__add_to_path /usr/bin
__add_to_path /usr/sbin
__add_to_path /bin
__add_to_path /sbin

# Cleanup helper function
functions -e __add_to_path
