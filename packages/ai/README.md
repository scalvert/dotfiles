# Personal AI Stack

This package is the source of truth for Steve's personal AI development environment.

It owns durable, reviewable configuration:

- skill and prompt inventory
- MCP server catalog
- agent definitions and ownership notes
- feedback-loop policy
- archive decisions

It does not own app state, auth tokens, chat history, generated caches, or machine-local trust decisions.

`registry.yaml` is the canonical inventory and lifecycle decision file. See
`REGISTRY.md` for the required structure.

## Layout

```text
packages/ai/
  registry.yaml       # Canonical inventory and lifecycle decisions
  commands/           # Canonical command specs for generated client shims
  generated/          # Generated per-client artifacts, reviewed before install
  mcp/servers.json    # Public-safe shared stdio MCP catalog
  prompts/            # Reusable prompt source material
  skills/             # Skill source-of-truth notes and manifests
  agents/             # Agent definitions and ownership notes
  feedback/           # Usage and improvement feedback loop
  archive/            # Retired decisions before deletion
```

## Rules

1. Add new reusable AI behavior here first.
2. Tool-specific folders are generated or synchronized consumers whenever practical.
3. Archive before deleting.
4. Secrets stay in local files, keychains, or app-owned auth stores.
5. Project-specific behavior belongs in the project unless it is broadly reusable.

Prompt files under `prompts/` must include frontmatter with `id`, `status`,
`source`, and `clients`. The `id` must match the filename.

Command specs under `commands/` must include a numeric `version` and a non-empty
`commands` array with unique kebab-case ids and all fields needed by the
generator.

MCP servers under `mcp/servers.json` must be public-safe portable stdio servers.
Private HTTP URLs, headers, environment variables, auth, and project-specific
servers stay local.

Agent manifests under `agents/` must define explicit, task-scoped agents with
narrow purposes. Avoid implicit always-on orchestration.

## Completion Audit

Run the ongoing goal audit:

```bash
mise run ai:completion:audit
```

Run strict mode only when the full consolidation goal should be complete:

```bash
mise run ai:completion:audit:strict
```

Fresh-machine bootstrap verification records live in
`bootstrap-verifications/`. Copy the template after a real test run; the audit
does not count the template itself as proof.

## MCP

`mcp/servers.json` contains only public-safe stdio servers. Private HTTP MCP servers, auth headers, and company-specific URLs belong in local client config.

Generate client profiles:

```bash
mise run ai:generate:mcp
mise run ai:diff:mcp
```
