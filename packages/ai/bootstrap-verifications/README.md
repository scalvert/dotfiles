# Bootstrap Verifications

This directory stores sanitized evidence that the mise-first bootstrap and reset
flows have been tested on a disposable or fresh machine.

Do commit:

- date
- platform family and architecture
- repository commit
- commands that were run
- pass/fail result
- sanitized notes about failures or follow-up work

Do not commit:

- hostnames
- usernames
- absolute home-directory paths
- secrets, tokens, auth output, or key material
- full Homebrew, mise, shell, or app logs
- private company URLs or internal repository names

Preferred workflow:

```bash
curl -fsSL https://raw.githubusercontent.com/scalvert/dotfiles/main/install | bash
cd ~/workspace/personal/dotfiles
AI_BOOTSTRAP_VERIFY_ENVIRONMENT=fresh-machine mise run ai:bootstrap:verify:preflight
AI_BOOTSTRAP_VERIFY_ENVIRONMENT=fresh-machine mise run ai:bootstrap:verify
```

Use `AI_BOOTSTRAP_VERIFY_ENVIRONMENT=disposable-vm` for a VM/container-style
test or `AI_BOOTSTRAP_VERIFY_ENVIRONMENT=clean-user` for a clean local user
account. The verifier requires the local bootstrap success marker written by
the installer, runs the required gates, and writes a pass record only if every
gate succeeds.

Do not treat a temporary `HOME` under an existing login session as a clean-user
verification. Homebrew, macOS preferences, and other system-level tools are not
fully isolated by changing `HOME`; use a real disposable VM, fresh machine, or
separate OS user account. The preflight rejects the obvious unsafe case, but it
does not replace judgment about whether the machine is truly isolated.

Manual fallback: copy `TEMPLATE.md` to a dated file after a real verification
run. The completion audit only treats a non-template file as proof when it
includes:

- `date: YYYY-MM-DD` with a real date
- `result: pass`
- `platform: darwin` or `platform: linux`
- `arch: arm64` or `arch: x86_64`
- `dotfiles_commit: SHORT_SHA` replaced with a real 7-40 character commit SHA
- `environment: fresh-machine`, `environment: disposable-vm`, or `environment: clean-user`
- `verified_by: steve` or another sanitized handle matching `[A-Za-z0-9_-]+`
- the required command list from `TEMPLATE.md`

## Failure Records

`mise run ai:bootstrap:verify` writes sanitized failure records under
`failures/` when preflight, installer-marker, or verification-gate checks fail.
These records are for follow-up work only. They never count as completion proof.
