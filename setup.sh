#!/bin/sh

# Homebrew Script for OSX
# To execute: save and `chmod +x ./setup.sh` then `./setup.sh`

sudo chown -R $(whoami) /usr/local/Cellar

echo "Installing brew..."
/usr/bin/ruby \
	-e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
	</dev/null

echo "Installing brew bundle..."
brew tap Homebrew/bundle

echo "Executing Brewfile"
brew bundle

echo "Copying dotfiles"
cp -r dotfiles/* ~/
