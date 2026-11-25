function gh-work --description "Use the work GitHub account in this shell"
    # Point gh at the work config directory. It holds one account, so there is
    # nothing to switch. On a new machine, follow with: gh auth login
    # (choose the protocol your employer uses)
    set -gx GH_CONFIG_DIR (__gh_work_config_dir)
    echo "gh now uses $GH_CONFIG_DIR (work) until the next cd"
end
