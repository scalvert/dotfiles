# Feedback Loop

The feedback loop should improve skills without turning every chat into a permanent instruction.

## Inputs

- explicit user corrections
- repeated manual edits after AI-generated work
- tool failures and denied plans
- stale skills that have not been used recently
- duplicate skills or commands with overlapping intent

## Review Cadence

Run a monthly review:

1. Inventory installed skills and commands.
2. Compare names, descriptions, source hashes, and local content hashes.
3. Flag unused, duplicate, missing, or drifted skills.
4. Propose prompt edits as patches.
5. Archive superseded material.

Preferred command:

```bash
mise run ai:feedback
```

Use `mise run ai:skill:drift` to compare the live managed-skill lockfile against the local generated `packages/ai/skills/managed-lock.snapshot.tsv`. Treat missing local directories, missing upstream hashes, or local content hash changes as review items, not automatic delete signals.

## Rules

- Do not auto-edit global instructions from a single event.
- Prefer specific skill updates over broader personality rules.
- Keep raw usage logs local. Commit only summarized decisions.
- Archive before delete.
