# Aliases and Abbreviations
# Common shortcuts and command replacements

# Modern CLI replacements
alias ls 'eza -la'
alias l. 'ls -d .* --color=auto'
alias cat 'bat'

# Editor
alias vi nvim
alias vim nvim

# Navigation
alias c clear
alias h history
alias j 'jobs -l'

# File operations (with safety)
alias mv 'mv -i'
alias cp 'cp -i'
alias ln 'ln -i'

# Utilities
alias md glow
alias br broot
alias now 'date +"%T"'

# Network
alias ip 'ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2'

# Grep with color
alias grep 'grep --color=auto'

# Google Cloud
alias gauth 'gcloud auth login --update-adc'

# Git shortcuts (using abbreviations for better completion)
abbr -a g git
abbr -a gst 'git status -sb'
abbr -a gap 'git add -p'
abbr -a gd 'git diff'
abbr -a gds 'git diff --staged'
abbr -a gc 'git commit --verbose'
abbr -a gco 'git checkout'
abbr -a gb 'git branch'
abbr -a gl 'git log --oneline'
abbr -a gp 'git push'
abbr -a gpl 'git pull'

# Tmux
abbr -a t tmux
abbr -a ta 'tmux attach'
abbr -a tl 'tmux list-sessions'

# Task runner
abbr -a mr 'mise run'
abbr -a mt 'mise tasks ls --local'

# Color settings for ls
set -gx CLICOLOR 1
set -gx LSCOLORS gxBxhxDxfxhxhxhxhxcxcx
