# Mise Task Migration

Steve has moved away from go-task in favor of mise. The target state is for this repo's operational entrypoints to be native mise tasks.

## Recommendation

Use `mise.toml` for thin orchestration tasks that call stable scripts. Use file tasks under `.mise/tasks` later for long shell bodies that deserve syntax highlighting and standalone testing.

Rationale:

- The existing go-task graph mixes simple wrappers, platform checks, loops, and long shell snippets.
- The safest first migration is to move stable script-backed tasks first.
- Long YAML-embedded shell blocks should become real scripts before they become mise file tasks.
- The existing `Taskfile.dist.yml` should remain until fresh-machine bootstrap no longer depends on it.

## Current State

Native mise tasks now exist for:

- `ai:*`
- `bootstrap:*`
- `brew:*`
- `system:install`
- `binutils:*`
- `dotfiles:install`
- `shell:update`
- `nvim:*`
- `mise:install`
- `mise:update`
- `mise:outdated`

Run:

```bash
mise trust
mise tasks ls --local
mise run bootstrap:preflight
mise run ai:validate
mise run ai:report
mise run mise:outdated
```

The go-task files still exist as compatibility while the rest of the migration is staged.

Mise requires project configs to be trusted before running tasks. For one-off validation without writing trust state, set `MISE_TRUSTED_CONFIG_PATHS` to the checkout path.

## Migration Order

1. AI stack tasks
   - Already migrated to native mise tasks because they are script-backed and low risk.

2. mise maintenance tasks
   - Already migrated to native mise tasks.

3. Bootstrap and status tasks
   - Migrated through `scripts/bootstrap`.

4. Brew/system tasks
   - Migrated through native mise task wrappers.
   - Keep install and update flows separate as the task surface evolves.

5. Shell/dotfiles/binutils tasks
   - Migrated through `scripts/binutils` and `scripts/dotfiles`.

6. Neovim/secrets tasks
   - Neovim tasks are migrated through `scripts/nvim`.
   - Secrets tasks still need migration.

7. Bootstrap installer
   - Migrated: install Homebrew and mise first, then run `mise run install`.

8. Retire go-task
   - Delete `Taskfile.dist.yml` and `taskfiles/` only after `mise tasks ls`, `mise run install`, reset flows, and fresh-machine bootstrap have been verified.

## Cutover Rule

Do not delete a go-task task until the equivalent mise task exists, has a documented command, and has been run or dry-run verified.
