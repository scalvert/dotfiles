function gh-personal --description "Use the personal GitHub account (scalvert) in this shell"
    # Point gh at the personal config directory. It holds one account, so there
    # is nothing to switch. On a new machine, follow with: gh auth login
    # (choose HTTPS; scripts/stack clones over HTTPS with this account)
    set -gx GH_CONFIG_DIR "$HOME/.config/gh-scalvert"
    echo "gh now uses $GH_CONFIG_DIR (personal) until the next cd"
end
