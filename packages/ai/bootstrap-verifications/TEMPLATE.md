---
date: YYYY-MM-DD
result: pass
platform: darwin|linux
arch: arm64|x86_64
dotfiles_commit: SHORT_SHA
environment: fresh-machine|disposable-vm|clean-user
verified_by: steve
---

# Fresh-Machine Bootstrap Verification - YYYY-MM-DD

## Scope

- mise-first bootstrap from `install`
- primary install task graph
- AI stack validation
- non-destructive reset dry runs
- go-task retirement gate

## Commands

```bash
curl -fsSL https://raw.githubusercontent.com/scalvert/dotfiles/main/install | bash
mise run ai:validate
mise run ai:doctor
mise run ai:completion:audit
mise run migration:go-task:retire-check
mise run ai:reset:dry-run
mise run reset:dry-run
```

## Result

Pass/fail:

## Sanitized Notes

- Do not paste raw logs.
- Record only the failing command name, brief symptom, and follow-up decision.
- Prefer generating this file with `AI_BOOTSTRAP_VERIFY_ENVIRONMENT=fresh-machine mise run ai:bootstrap:verify`.
