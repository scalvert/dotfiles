# Archived go-task Assets

This directory holds go-task support files removed from the active dotfiles
surface while migrating task entrypoints to mise.

The old shell completion has already been archived under `zsh-completion/`.

The compatibility Taskfiles still live at the repository root and under
`taskfiles/` until fresh-machine bootstrap and reset flows have been verified
without go-task. After verification, run:

```bash
mise run migration:go-task:archive-compat
```

That command moves `Taskfile.dist.yml` and `taskfiles/` into
`archive/go-task/compatibility/` so the historical task graph remains available
without being part of the active root surface.
