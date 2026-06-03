# Skills

Canonical reusable skill source belongs here. Tool-specific installed skill folders should be treated as consumers.

Current policy:

- Keep managed external bundles tracked by lock metadata.
- Consolidate custom Plannotator skills into one source package before deleting duplicates.
- Keep Cursor built-ins Cursor-managed.
- Keep project-specific skills in the project unless they are reused across projects.
- Archive retired skills before deletion.
- Generate managed-skill lock metadata locally in `managed-lock.snapshot.tsv`; use drift reports to decide whether to update, reinstall, archive, or remove stale lock entries.

Preferred skill shape:

```text
skills/<id>/
  SKILL.md
  agents/*.yaml        # optional client-neutral agent hints
  references/*         # optional supporting docs
  manifest.yaml        # origin, clients, status, owner, last_used
```
