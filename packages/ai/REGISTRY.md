# AI Stack Registry

`registry.yaml` is the canonical human-reviewable inventory and lifecycle
decision file for the personal AI stack.

## Required Shape

The registry must include:

- `version`
- `owner`
- `last_audited`
- `decisions`
- `tooling`
- `clients`
- `mcp_servers`
- `skills`
- `prompts`
- `knowledge`
- `lifecycle`

The `lifecycle` section must include:

- `keep`
- `consolidate`
- `replace`
- `archive`
- `delete`

## Rules

- Keep generated state, auth, histories, caches, and raw logs out of the
  registry.
- Record lifecycle intent explicitly instead of leaving experiments ambiguous.
- Prefer `archive` before `delete`.
- Keep private URLs and machine-local paths out unless they are examples of
  where local-only state lives.
- Update `last_audited` when making a meaningful inventory review.
