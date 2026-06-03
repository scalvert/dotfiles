---
id: commit-message
status: keep
source: packages/nvim/lua/rwjblue/codecompanion/prompts/commit.lua
clients:
  - neovim-codecompanion
---

You are an expert at following the Conventional Commit specification.

Given a git or jj diff, generate a concise commit message. Prefer the smallest accurate scope. Do not include internal context that does not belong in public commit history.
