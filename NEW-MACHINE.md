# New machine setup

A runbook for standing up a fresh Mac with this stack. Hand this to Claude Code on the new machine, or follow it yourself. The stack is **composed** (see [STACK.md](STACK.md)): this public `dotfiles` repo orchestrates; `wiki` (private) and `skills` (public) are cloned in.

## Automated vs manual

- **Automated** by `mise run install`: Homebrew + base Brewfile apps, mise tools, dotfile symlinks, AI stack, nvim, and cloning the `wiki`/`skills` repos.
- **Manual** (trust boundaries — credentials never live in a public repo): signing into 1Password, `gh` auth, filling the work git identity, recreating machine-local config.

## Steps

### 1. Bootstrap
```sh
curl -fsSL https://raw.githubusercontent.com/scalvert/dotfiles/main/install | bash
```
Installs Xcode CLI tools, Homebrew, mise, clones this repo, runs `mise run install`. Complete any sudo / Xcode GUI prompts when they appear.

### 2. 1Password (the secrets backbone)
- Launch 1Password (installed via the Brewfile) and sign in.
- Enable the SSH agent: **Settings → Developer → Use the SSH agent**.
- This provides SSH auth keys, the commit-signing key, and the Anthropic API key (via `op read` in `conf.d/40-ai.fish`). Nothing secret touches disk.

### 3. GitHub identities
```sh
gh-personal; gh auth login     # scalvert (personal)
gh-work;     gh auth login      # work account
```

### 4. Pull the stack (if install didn't already)
```sh
mise run stack:install          # clones wiki + skills into ~/workspace/personal
```

### 5. Work machine only — extra apps + work identity
```sh
mise run brew:work              # gpg-suite, redis-stack, Okta Verify, etc.
$EDITOR ~/.gitconfig.local       # set your WORK name + email (ships as a placeholder)
```
The personal identity under `~/workspace/personal` is automatic via `includeIf`.

### 6. Recreate machine-local config
- `~/.config/fish/local.fish` from `packages/fish/local.fish.template` — Vertex config (if you use Vertex for Claude Code) + any machine paths. The API key is **not** here; 1Password handles it.
- `~/.config/git/allowed_signers` (to verify your own signed commits):
  ```sh
  echo "$(git config user.email) $(git config user.signingkey)" > ~/.config/git/allowed_signers
  ```
- On demand as needed: `npm login`, `gcloud auth login` + `gcloud auth application-default login`.

### 7. Verify
```sh
mise run git:doctor             # identity split + drift; fix .gitconfig.local if it warns
wiki                            # opens the LLM wiki
ssh -T git@github.com           # confirms 1Password SSH-agent auth
git commit --allow-empty -m test; and git log --show-signature -1   # confirms signing
```

## Notes

- **No secret transfer.** The old GPG tarball (`secrets:export/import`) was retired. SSH keys, commit signing, and the API key all come from 1Password; `gh`/`npm`/`gcloud` re-auth on demand. The only manual secret action is signing into 1Password.
- If `echo $AI_CLAUDE_API_KEY` is empty: confirm `op` is signed in and the `Anthropic API Key` item exists in the vault referenced by `conf.d/40-ai.fish` (default `Private`). A work machine on a *different* 1Password account needs that item in that account's vault.
- **GPG** keys were intentionally dropped — signing is SSH-based via 1Password.
