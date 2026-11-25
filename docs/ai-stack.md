# Personal AI Stack

This document describes the target architecture for a unified, reproducible personal AI environment.

## Decision

Keep `scalvert/dotfiles` as the foundation. A new repository would duplicate the existing bootstrap, Taskfile, Homebrew, mise, shell, editor, and package structure. The problem is fragmentation above that foundation, not the foundation itself.

Add `packages/ai` as the canonical layer for durable AI configuration:

- inventory and lifecycle decisions in `packages/ai/registry.yaml`
- command definitions in `packages/ai/commands`
- generated client shims in `packages/ai/generated`
- reusable prompts in `packages/ai/prompts`
- reusable skills in `packages/ai/skills`
- explicit agent definitions in `packages/ai/agents`
- MCP catalog and generated/shared profiles in `packages/ai/mcp`
- feedback policy in `packages/ai/feedback`
- retired material in `packages/ai/archive`

## What Stays Local

Do not commit:

- API keys, OAuth tokens, app auth files, or keychain material
- Claude/Codex/Cursor histories
- app caches, telemetry, SQLite state, and session files
- machine-local trust lists
- project-specific generated skill caches

## Categorization

Keep:

- existing dotfiles bootstrap
- Homebrew as the macOS package layer
- mise as the runtime/tool version layer
- fish as the primary shell
- Neovim CodeCompanion as an editor client
- Glean, Google Workspace, and Linear as external knowledge/workflow integrations
- Obsidian as personal long-term notes

Consolidate:

- duplicated Plannotator skills and commands across Claude, Codex, `.agents`, and opencode
- reusable prompt text from CodeCompanion/Cursor into `packages/ai/prompts`
- MCP server definitions into one catalog with per-client generated profiles
- global behavior preferences from `~/.claude/CLAUDE.md` into reviewable shared policy

Replace:

- implicit always-on multi-agent orchestration embedded in one client with explicit, task-scoped agents

Archive:

- inactive Goose, Crush, and Superpowers experiments until an active workflow justifies keeping them
- duplicate command shims after generated replacements exist

Delete:

- nothing in the first pass

## Skill Representation

Use markdown for instruction bodies because it is readable, portable, and already supported by Claude/Codex/Cursor-style skill systems. Add small structured manifests for lifecycle metadata.

Preferred shape:

```text
packages/ai/skills/<id>/
  SKILL.md
  manifest.yaml
  agents/*.yaml
  references/*
```

The manifest should track owner, status, source, target clients, last reviewed date, and replacement/archive notes. Client-specific folders should be generated or synchronized from this structure when practical.

## Skills and Plugins Manifest

`packages/ai/skills.json` declares every agent skill and plugin. One command installs them all:

```bash
mise run ai:skills:install
```

`mise run install` runs it as a phase, so a fresh machine gets the full set.

The file has four parts:

- `agents`: the agents that `npx skills` links skills into.
- `skillsCli`: the version of the `skills` npm package that the restore runs. Bump it to move to a newer `npx skills`.
- `plugins`: for the `claude` and `codex` CLIs, the marketplaces to add and the plugins to install. Use a plugin when a package ships more than skills, such as hooks, agents, or shared docs. `scalvert/skills` and the Elephant-Goldfish Model are plugins for that reason.
- `skills` and `lockVersion`: the body of a `skills-lock.json`, as `npx skills` writes it. Each GitHub entry pins a commit, so a restore installs the version that was reviewed.

`scripts/skills install` writes the `skills` part to `~/skills-lock.json` and runs `npx skills install` from `$HOME`. That installs into `~/.agents/skills` and links `~/.claude/skills`. The restore replaces the lock file, so the script copies it into `$HOME`. Do not symlink it.

Change the set from `$HOME`, then save the result back into the manifest. Use the `skills` version in `skillsCli`, so the lock is written by the same CLI that restores it:

```bash
cd ~
npx skills@1.9.0 add <owner/repo> --skill <name> --agent claude-code codex -y
npx skills@1.9.0 update -p -y    # move pinned skills to the latest commit
npx skills@1.9.0 remove <name> -y
mise run ai:skills:save          # copy ~/skills-lock.json into skills.json
mise run ai:skills:lock          # print the skills-lock.json the manifest describes
```

When you bump `skillsCli`, change the version in these commands too.

Notes:

- The restore does not remove a skill when its entry is deleted. `mise run ai:skills:status` lists skills that are missing and skills that are on disk but not declared.
- The plugin step fails when `claude` or `codex` is not on `PATH`. Install the CLI, then run the task again. Running it again is safe.
- `resolving-merge-conflicts` is pinned to the last `mattpocock/skills` commit that had it. Upstream removed it on 2026-09-24, so an update cannot find it.
- A package installed as a plugin must not also be listed under `skills`, or the agent loads every skill twice.

## Feedback Loop

Monthly:

1. Inventory installed skills, commands, prompts, MCP servers, and agents.
2. Compare names, descriptions, source hashes, local content hashes, and last-reviewed dates.
3. Flag duplicate, missing, drifted, and unused skills.
4. Convert repeated user corrections into narrow skill patches.
5. Archive superseded material before deletion.

The current review command reports duplicate skill names, duplicate command names, unclassified live skills, and explicit archive/dead-skill candidates:

```bash
mise run ai:review
mise run ai:feedback
mise run ai:usage
mise run ai:usage:report
mise run ai:prompt:plan
mise run ai:archive:plan
```

Managed external skills are tracked with a lightweight lock snapshot:

```bash
mise run ai:snapshot:skills
mise run ai:skill:drift
```

The snapshot records skill id, source type, source, skill path, upstream lock hash, local content hash, and update time. It does not store skill contents.
Snapshots and dated review reports are local generated state and are ignored by git.

Rules:

- Never promote a single correction into a global rule without review.
- Prefer updating a specific skill over expanding global personality instructions.
- Keep raw logs local; commit summarized decisions.
- Treat project-specific feedback as project-local unless it recurs elsewhere.

Usage reports are written to `${XDG_STATE_HOME:-~/.local/state}/ai-stack/usage`. Prompt improvement plans are written to `${XDG_STATE_HOME:-~/.local/state}/ai-stack/prompt-plans`. Archive and consolidation plans are written to `${XDG_STATE_HOME:-~/.local/state}/ai-stack/archive-plans`. They are local review artifacts and should not be committed unless manually sanitized.

## Bootstrap

Fresh machine:

```bash
curl -fsSL https://raw.githubusercontent.com/scalvert/dotfiles/main/install | bash
```

Local checkout:

```bash
./install
mise run ai:validate
mise run ai:doctor
mise run ai:completion:audit
mise run ai:inventory
mise run ai:live-inventory
mise run ai:review
mise run ai:report
mise run ai:usage:report
mise run ai:prompt:plan
mise run ai:archive:plan
mise run ai:snapshot:skills
mise run ai:skill:drift
mise run ai:generate:commands
mise run ai:diff:commands
mise run ai:generate:mcp
mise run ai:diff:mcp
mise run ai:install:commands:dry-run
mise run ai:reset:commands:dry-run
```

The bootstrap path uses mise. The old go-task task graph remains as a temporary compatibility layer while parity is verified.
Use `mise run ai:completion:audit` to inspect goal coverage. Use `mise run ai:completion:audit:strict` only when you expect the full consolidation goal, including fresh-machine verification, to be complete.
Record real fresh-machine bootstrap evidence after testing:

```bash
mise run ai:bootstrap:verification:plan
AI_BOOTSTRAP_VERIFY_ENVIRONMENT=fresh-machine mise run ai:bootstrap:verify:preflight
AI_BOOTSTRAP_VERIFY_ENVIRONMENT=fresh-machine mise run ai:bootstrap:verify
```

Use `AI_BOOTSTRAP_VERIFY_ENVIRONMENT=disposable-vm` for a VM/container-style test or `AI_BOOTSTRAP_VERIFY_ENVIRONMENT=clean-user` for a clean local user account. The verifier requires the local bootstrap success marker written by the installer, runs the required gates, and writes a sanitized pass record only if every gate succeeds.

`mise run ai:bootstrap:verification:plan` prints a copy-pasteable handoff for the current commit and target environment. It is an operator aid only; it does not satisfy the completion audit.

Do not use a temporary `HOME` inside an existing login session as the clean-user test. Homebrew and macOS preference writes are system/user-session level, so that does not provide enough isolation for bootstrap proof.

Failed bootstrap verification attempts are recorded under `packages/ai/bootstrap-verifications/failures/` for follow-up, but only non-template `result: pass` records in `packages/ai/bootstrap-verifications/` satisfy the completion audit.

## Uninstall / Reset

There is no one-shot destructive uninstall task by design. The supported uninstall path is a reversible reset of repo-managed surfaces, followed by explicit manual cleanup for anything broader.

The reset is intentionally non-destructive. It removes only repo-managed symlinks and generated command shims that have an install manifest. It leaves copied local templates, app-owned state, auth, caches, language runtimes, Homebrew packages, and secrets alone.

```bash
mise run ai:reset:dry-run
mise run reset:dry-run
```

Apply after reviewing the dry run:

```bash
mise run ai:reset
mise run reset
```

Stop here if the goal is to detach this checkout while preserving the working machine. Do not remove state or packages until the dry-run output has been reviewed and any local-only files have been archived.

Reinstall managed links:

```bash
mise run dotfiles:install
mise run ai:validate
mise run ai:doctor
```

Command shim install manifests and backups live under `${XDG_STATE_HOME:-~/.local/state}/ai-stack`, not under `~/.config/ai`, so they do not get written into the dotfiles checkout when `~/.config/ai` is symlinked to `packages/ai`.

Manual cleanup candidates, only after archiving and review:

- duplicate Plannotator command shims in Claude/opencode
- inactive experiment folders for Goose/Crush/Superpowers
- stale generated skill caches
- local state under `${XDG_STATE_HOME:-~/.local/state}/ai-stack` after reset manifests are no longer needed

## Generated Commands

Reusable commands are defined once under `packages/ai/commands`. Run:

```bash
mise run ai:generate:commands
```

Generated shims are written under `packages/ai/generated/commands/<client>`. Review those files before installing or archiving the older hand-written shims.

Compare generated command shims with live command files:

```bash
mise run ai:diff:commands
```

Preview install:

```bash
mise run ai:install:commands:dry-run
```

Apply install after review:

```bash
mise run ai:install:commands
```

The installer writes a manifest to `${XDG_STATE_HOME:-~/.local/state}/ai-stack/command-install-manifest.tsv` and backs up overwritten files under `${XDG_STATE_HOME:-~/.local/state}/ai-stack/backups/commands/<timestamp>`.

Preview reset:

```bash
mise run ai:reset:commands:dry-run
```

Apply reset:

```bash
mise run ai:reset:commands
```

Reset reads the install manifest in reverse order. Files that were created by the installer are removed; files that existed before install are restored from backup.

## MCP Profiles

The canonical public-safe MCP catalog lives at `packages/ai/mcp/servers.json`. It should include portable stdio servers only.

Generate reviewed client profiles:

```bash
mise run ai:generate:mcp
```

Generated files:

- `packages/ai/generated/mcp/shared/servers.json`
- `packages/ai/generated/mcp/cursor/mcp.json`
- `packages/ai/generated/mcp/codex/config.toml`

Compare generated profiles with live local config:

```bash
mise run ai:diff:mcp
```

Private HTTP MCP servers, OAuth headers, company URLs, and project-specific MCP config stay local. Add them to client-owned config files or project config, not to the public catalog.

## Next Increments

1. Run and record a sanitized fresh-machine bootstrap/reset verification under `packages/ai/bootstrap-verifications/`.
2. Remove or archive remaining go-task compatibility files after that verification.
3. Apply reviewed command shims and archive superseded manual Plannotator shims.
4. Promote reusable prompt text from client-specific wrappers into `packages/ai/prompts`.
