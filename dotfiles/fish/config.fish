
source $HOME/.aliases
source $HOME/.cargo/env

set -gx fish_complete_path /usr/local/var/homebrew/linked/fish/share/fish/completions/ $fish_complete_path
set -gx GITHUB_AUTH "797f5a8f378080d4cb1ff4168ead981c79e80503"
set -gx GITHUB_TOKEN "1a2a5e9951e57c263655651aac32403504d43719"

set -gx NODE_OPTIONS "--max-old-space-size=8192"

set -gx EDITOR "/usr/bin/vim"

thefuck --alias | source
# THEME PURE #
set fish_function_path /Users/scalvert/.config/fish/functions/theme-pure/functions/ $fish_function_path
source /Users/scalvert/.config/fish/functions/theme-pure/conf.d/pure.fish



set -gx VOLTA_HOME "/Users/scalvert/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
