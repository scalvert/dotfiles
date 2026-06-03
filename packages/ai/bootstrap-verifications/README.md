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

Copy `TEMPLATE.md` to a dated file after a real verification run. The
completion audit only treats a non-template file with `result: pass` as proof.
