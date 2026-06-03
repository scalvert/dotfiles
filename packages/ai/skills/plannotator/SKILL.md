# Plannotator

Use this skill when a workflow needs structured review feedback to be turned
into concrete edits or follow-up action.

## Purpose

Plannotator is the canonical source for review, annotation, and plan-feedback
workflows that were previously duplicated across Claude, Codex, `.agents`, and
opencode command surfaces.

Use it for:

- responding to annotated markdown or review feedback
- reviewing the last assistant response for actionable changes
- converting plan feedback into implementation steps
- keeping review loops explicit instead of adding broad always-on behavior

## Operating Rules

- Treat Plannotator output as review input, not as an automatic command to
  change unrelated files.
- Apply only the feedback that is actionable and relevant to the current task.
- Preserve local project conventions over generic suggestions.
- Keep generated command shims thin; update the canonical command spec before
  editing client-specific copies.
- Archive superseded manual command shims only after generated replacements
  have been reviewed and installed.

## Source Of Truth

- Command spec: `packages/ai/commands/plannotator.json`
- Generated shims: `packages/ai/generated/commands/<client>/`
- Lifecycle metadata: `packages/ai/skills/plannotator/manifest.yaml`
