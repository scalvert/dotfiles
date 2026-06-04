# Managed Skill Lock Orphans

Archived decision date: 2026-06-04

## Scope

The local managed skill lockfile contains entries for:

- `find-skills`
- `agent-browser`

Their corresponding local skill directories were not present during review:

- `~/.agents/skills/find-skills`
- `~/.agents/skills/agent-browser`

## Decision

Archive these as stale lock-only entries instead of reinstalling them by
default.

## Rationale

The target AI stack favors fewer reusable systems and explicit task-scoped
skills. Broad skill-discovery or browser-agent helpers should not be restored
only because stale lock metadata exists.

Reinstall one of these skills only if a current workflow needs it and a new
manifest records its owner, purpose, clients, source, and review cadence.

## Follow-Up

Remove the stale entries from the local managed skill lockfile after reviewing
the live environment. Do not commit the lockfile itself; it is machine-local
state.
