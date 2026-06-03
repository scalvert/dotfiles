# Commands

Canonical command specs live here. Generated client-specific command shims
should be produced from these specs instead of hand-maintained separately.

## Format

Each spec is JSON:

```json
{
  "version": 1,
  "commands": [
    {
      "id": "command-id",
      "description": "Short user-facing description",
      "title": "Rendered command title",
      "shell": "tool command $ARGUMENTS",
      "task": "What the assistant should do after command output is available.",
      "opencodeMessage": "opencode-specific user-facing handoff text."
    }
  ]
}
```

Rules:

- `version` must be a number.
- `commands` must be a non-empty array.
- `id` must be lowercase kebab-case and unique within the spec.
- `description`, `title`, `shell`, `task`, and `opencodeMessage` must be
  non-empty strings.
- Keep command specs public-safe. Do not commit auth, private URLs, local paths,
  raw logs, or client-owned history.
