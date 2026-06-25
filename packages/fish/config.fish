# Fish Shell Configuration
# fish auto-sources conf.d/*.fish on startup, so we do NOT source it again here
# (doing so ran every integration twice and spewed errors on reload).

# Source machine-local config/secrets if present (not tracked in git).
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
