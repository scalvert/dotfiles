# scalvert/dotfiles

A modern dotfiles setup for macOS and Linux with seamless bootstrap from a fresh machine.

> **Attribution**: This dotfiles repository is based on [rwjblue/dotfiles](https://github.com/rwjblue/dotfiles) by [Robert Jackson](https://github.com/rwjblue). The original structure, task system, and many configurations come from his excellent work.

## Quick Start

### One-Liner Install (Fresh Machine)

```bash
curl -fsSL https://raw.githubusercontent.com/scalvert/dotfiles/main/install | bash
```

This will:
1. Install Xcode CLI tools (macOS)
2. Install Homebrew
3. Install mise
4. Clone this repository
5. Run the full installation through `mise run install`

### Local Install

```sh
./install
```

To force a re-install (clobbering existing files):

```sh
FORCE=true ./install
```

## Available Tasks

Native mise tasks are the preferred task interface. See [Mise Task Migration](docs/mise-task-migration.md).

```console
mise tasks ls --local
mise run bootstrap:status
mise run install
mise run reset:dry-run
mise run ai:validate
mise run ai:doctor
mise run ai:completion:audit
mise run ai:feedback
mise run ai:report
mise run migration:go-task:retire-check
mise run migration:go-task:archive-compat:dry-run
```

The legacy go-task graph is no longer a preferred interface. `Taskfile.dist.yml`
and `taskfiles/` remain only as temporary compatibility until a fresh bootstrap
verification record exists, then `mise run migration:go-task:archive-compat`
archives them under `archive/go-task/compatibility/`.

## What's Included

### Shell Configuration

- **Fish** (primary) - Modern shell with smart completions
  - Pure prompt theme
  - Organized conf.d structure
  - Modern CLI tool aliases
- **Zsh** - Fallback configuration
- **Bash** - Basic configuration

### Modern CLI Tools

| Traditional | Modern | Notes |
|------------|--------|-------|
| `ls` | `eza` | Colors, icons, git status |
| `cat` | `bat` | Syntax highlighting |
| `find` | `fd` | Faster, simpler |
| `grep` | `rg` | Respects gitignore |
| `cd` | `zoxide` | Smart jumping |
| `du` | `dust` | Visual |
| `df` | `duf` | Pretty |
| `ps` | `procs` | Colored |
| `htop` | `bottom` | Modern TUI (btm) |

See [docs/modern-cli.md](docs/modern-cli.md) for complete reference.

### Terminal Emulators

- **Ghostty** - Fast, GPU-accelerated
- **WezTerm** - Cross-platform, configurable
- **iTerm2** - Feature-rich (macOS)

### Editor

- **Neovim** - LazyVim-based configuration
  - AI integration (Claude, CodeCompanion)
  - LSP support for many languages
  - Custom snippets

### Other Tools

- **Git** - Delta for diffs, LFS, filter-repo
- **tmux** - Terminal multiplexer
- **Hammerspoon** - macOS automation
- **Alfred** - Snippets and workflows

## Secrets Management

Export secrets before migrating to a new machine:

```bash
mise run secrets:export
# Creates: secrets-YYYYMMDD.tar.gpg
```

Import on new machine:

```bash
mise run secrets:import -- secrets-20260201.tar.gpg
```

See [packages/secrets/README.md](packages/secrets/README.md) for details.

## Configuration Files

After installation, create `~/.config/fish/local.fish` for secrets:

```fish
# API Keys (not tracked in git)
set -gx AI_CLAUDE_API_KEY "sk-ant-..."
set -gx GITHUB_TOKEN "ghp_..."
```

## Documentation

- [Modern CLI Tools](docs/modern-cli.md) - Reference for modern command replacements
- [Claude Setup](docs/claude-setup.md) - AI tool configuration
- [Secrets Management](packages/secrets/README.md) - Export/import secrets
- [iTerm2 Setup](packages/iterm2/README.md) - iTerm2 configuration

## Project Structure

```
.
├── install                 # Bootstrap installer
├── Brewfile                # Homebrew packages
├── mise.toml               # Primary task runner config
├── scripts/                # Script-backed mise task implementations
├── Taskfile.dist.yml       # Temporary legacy go-task compatibility config
├── taskfiles/              # Temporary legacy task definitions during migration
├── packages/               # Configuration packages
│   ├── fish/               # Fish shell config
│   │   ├── config.fish
│   │   ├── conf.d/         # Modular config files
│   │   ├── functions/      # Custom functions
│   │   └── completions/    # Custom completions
│   ├── nvim/               # Neovim config
│   ├── git/                # Git config
│   ├── tmux/               # tmux config
│   ├── iterm2/             # iTerm2 profiles
│   ├── secrets/            # Export/import scripts
│   ├── claude/             # Claude Code templates
│   ├── mcp/                # MCP server config
│   └── ...
└── docs/                   # Documentation
```

## Troubleshooting

### Neovim Strikethrough/Undercurl Support

Follow [these instructions](https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines) for terminal compatibility.

### Fish Shell Not Loading

1. Check symlink: `ls -la ~/.config/fish`
2. Verify local.fish exists: `cat ~/.config/fish/local.fish`
3. Reload: `exec fish`

### GPG Agent Issues

```bash
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
```

## Credits & Inspiration

This dotfiles repository is forked from and heavily based on:

- **[rwjblue/dotfiles](https://github.com/rwjblue/dotfiles)** by [Robert Jackson](https://github.com/rwjblue) - The foundation for this entire setup, including the task-based architecture, package structure, and most configurations.

Additional inspiration from:

- [hjdivad/dotfiles](https://github.com/hjdivad/dotfiles)
- [dkarter/dotfiles](https://github.com/dkarter/dotfiles)
