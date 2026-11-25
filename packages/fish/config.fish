# Fish Shell Configuration
# fish auto-sources conf.d/*.fish on startup, so we do NOT source it again here
# (doing so ran every integration twice and spewed errors on reload).

# Source machine-local config/secrets if present (not tracked in git).
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

# Set GH_CONFIG_DIR for the starting directory. This runs here, not in
# conf.d/30-integrations.fish, so a GH_WORK_CONFIG_DIR set in local.fish
# applies before the first cd.
if functions -q __gh_set_config_dir
    __gh_set_config_dir
end
