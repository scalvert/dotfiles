# Stack

My portable personal stack: a set of repos cloned and wired onto every machine by this dotfiles repo. **Composed, not merged** — each repo keeps its own visibility, identity, and lifecycle. dotfiles is the orchestrator, not a container.

## Repos

| Repo | Visibility | Role |
|---|---|---|
| `scalvert/dotfiles` | public | This repo. Orchestrator + machine config + managed AI config (`packages/ai`). |
| `scalvert/wiki` | private | Personal LLM wiki — knowledge, journal, decisions. Driven by the `wiki` command. |
| `scalvert/skills` | public | Authored Agent Skills (agentskills.io-compatible). |

The composition manifest is `scripts/stack` (`STACK_REPOS`). To add a repo to the stack, add one line there.

## Fresh machine

1. **Bootstrap dotfiles:**
   ```sh
   curl -fsSL https://raw.githubusercontent.com/scalvert/dotfiles/main/install | bash
   ```
   Installs Homebrew + mise, clones this repo, runs `mise run install`.

2. **Authenticate the personal identity** (required to clone the personal/private stack repos):
   ```sh
   gh-personal; gh auth login
   ```

3. **Pull the stack:**
   ```sh
   mise run stack:install
   ```
   Clones `wiki` + `skills` into `~/workspace/personal/`. The main `install` runs this too — it skips gracefully if step 2 hasn't happened yet, so just re-run it once authenticated.

## Identity model

Everything under `~/workspace/personal/` uses the **personal** identity: git via `includeIf` (→ `~/.gitconfig-personal`), and `gh` via a PWD-scoped `GH_CONFIG_DIR` → `~/.config/gh-scalvert` (see `packages/fish/conf.d/30-integrations.fish`). The **work** identity is the default everywhere else. This split is why the stack is composed rather than merged — one repo can't hold two visibility classes or two identities cleanly.
