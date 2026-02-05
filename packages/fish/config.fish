# Fish Shell Configuration
# Main config file - sources conf.d files in order

# Source all conf.d files in order
for file in ~/.config/fish/conf.d/*.fish
    source $file
end

# Source local secrets if available (not tracked in git)
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
