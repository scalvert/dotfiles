# Agents

Agent definitions should be explicit, narrow, and owned by this package only when they are broadly useful.

Prefer fewer agents:

- reviewer: independent review and risk finding
- researcher: documentation and source discovery
- executor: implementation in a known repo
- verifier: test and validation pass

Avoid always-on orchestration layers unless the task requires them. Client-specific agent wiring should be generated from shared definitions where possible.

## Manifest Shape

Each agent set uses a small `manifest.yaml`:

```yaml
id: core-agents
status: proposed
owner: steve
last_reviewed: YYYY-MM-DD
description: Short purpose for the set.
agents:
  reviewer:
    purpose: Independent review for risks, bugs, missing tests, and regressions.
decision:
  replace: broad implicit orchestration
  keep: explicit delegation when useful
```

Rules:

- Prefer a small stable set over broad always-on orchestration.
- Each agent must have a narrow `purpose`.
- Agent manifests should describe when to replace, keep, archive, or avoid an
  agent pattern.
- Client-specific agent wiring should be generated or adapted from this source,
  not treated as the canonical definition.
