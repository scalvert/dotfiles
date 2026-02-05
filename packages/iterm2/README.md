# iTerm2 Configuration

This directory contains iTerm2 settings and profiles.

## Files

- `Profiles.json` - iTerm2 profiles (Default, Visor, Light Visor, tmux)
- `com.googlecode.iterm2.plist` - Full iTerm2 preferences

## Setup

To use these settings, configure iTerm2 to load preferences from this directory:

1. Open iTerm2
2. Go to Preferences > General > Preferences
3. Check "Load preferences from a custom folder or URL"
4. Set the path to: `~/.config/iterm2` (or wherever this is symlinked)
5. Check "Save changes to folder when iTerm2 quits"

Alternatively, run this command:

```bash
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.config/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
```

## Profiles

| Profile | Description |
|---------|-------------|
| Default | Main profile with standard settings |
| Visor | Hotkey-activated dropdown terminal |
| Light Visor | Light-themed visor variant |
| tmux | Profile optimized for tmux usage |
