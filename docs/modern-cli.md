# Modern CLI Tools Reference

This dotfiles setup includes modern replacements for traditional Unix commands.
These tools are faster, more intuitive, and often provide better output formatting.

## Quick Reference

| Traditional | Modern | Command | Notes |
|------------|--------|---------|-------|
| `ls` | `eza` | `ls` (aliased) | Colors, icons, git status |
| `cat` | `bat` | `bat` or `cat` (aliased) | Syntax highlighting, line numbers |
| `find` | `fd` | `fd` | Simpler syntax, respects .gitignore |
| `grep` | `rg` | `rg` | Much faster, respects .gitignore |
| `cd` | `zoxide` | `z` | Smart directory jumping |
| `du` | `dust` | `dust` | Visual directory sizes |
| `df` | `duf` | `duf` | Pretty disk usage |
| `ps` | `procs` | `procs` | Colored, searchable |
| `top`/`htop` | `bottom` | `btm` | Modern TUI, graphs |
| `diff` | `delta` | `git diff` uses it | Better git diffs |
| `man` | `tldr` | `tldr` | Practical examples |

## Tool Details

### eza (ls replacement)

```bash
# Already aliased to 'ls' in fish config
ls              # List with details and icons
ls -T           # Tree view
ls --git        # Show git status
```

### bat (cat replacement)

```bash
bat file.py     # Syntax highlighting
bat -p file.py  # Plain mode (no line numbers)
bat -A file.py  # Show non-printable characters
```

### fd (find replacement)

```bash
fd pattern              # Find files matching pattern
fd -e py                # Find by extension
fd -t d                 # Find directories only
fd pattern --exec cmd   # Execute command on results
```

### ripgrep (grep replacement)

```bash
rg pattern              # Search in current directory
rg pattern -t py        # Search only Python files
rg pattern -g '*.json'  # Search with glob filter
rg -i pattern           # Case-insensitive
rg -C 3 pattern         # Show 3 lines of context
```

### zoxide (cd replacement)

```bash
z projects      # Jump to most frecent 'projects' directory
z foo bar       # Jump to directory matching both 'foo' and 'bar'
zi              # Interactive selection with fzf
```

### dust (du replacement)

```bash
dust            # Visual size of current directory
dust -d 2       # Limit depth to 2 levels
dust /path      # Analyze specific path
```

### duf (df replacement)

```bash
duf             # Pretty disk usage
duf /           # Show specific mount point
duf --json      # JSON output
```

### procs (ps replacement)

```bash
procs           # List all processes
procs firefox   # Search for process
procs --tree    # Process tree
procs -w        # Watch mode
```

### bottom (htop replacement)

```bash
btm             # Launch bottom
btm -b          # Basic mode (no graphs)
btm -g          # Grouped processes
```

### fzf (fuzzy finder)

```bash
# Ctrl+R         # Fuzzy history search (if atuin not active)
# Ctrl+T         # Fuzzy file search
# Alt+C          # Fuzzy cd
vim $(fzf)      # Open file selected with fzf
```

### delta (diff tool)

Automatically used by git for diffs. Configuration in `.gitconfig`.

### tldr (man replacement)

```bash
tldr tar        # Practical tar examples
tldr --update   # Update local cache
```

## Installation

All tools are installed via Homebrew:

```bash
mise run brew:install
```

Or install individually:

```bash
brew install eza bat fd ripgrep zoxide dust duf procs bottom fzf git-delta tealdeer
```

## Configuration

Most tools are configured in:
- `packages/fish/conf.d/20-aliases.fish` - Aliases
- `packages/fish/conf.d/30-integrations.fish` - Tool integrations
- `packages/git/gitconfig` - Git delta configuration
