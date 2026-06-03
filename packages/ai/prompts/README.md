# Prompts

Reusable prompt source material belongs here when it is useful across tools or
clients.

Keep prompts small and portable. Tool-specific command wrappers should import,
copy, or generate from these files when practical.

## Frontmatter

Each prompt must include YAML-style frontmatter:

```yaml
---
id: prompt-id
status: keep|consolidate|archive
source: path-or-system
clients:
  - client-name
---
```

Rules:

- `id` must match the filename without `.md`.
- `status` records lifecycle intent.
- `source` records where the prompt came from.
- `clients` records known consumers.
- Do not commit secrets, internal documents, chat history, or raw private logs.
