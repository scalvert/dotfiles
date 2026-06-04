# Bootstrap Verification Failures

This directory stores sanitized failure records from real bootstrap verification
attempts. Failure records are useful for follow-up work, but they never count as
completion proof.

Commit records here only when they come from a real fresh-machine, disposable
VM, or separate OS-user verification attempt.

Do not commit:

- raw command logs
- hostnames
- usernames
- absolute home-directory paths
- secrets, tokens, auth output, or key material
- private company URLs or internal repository names

The pass-record audit intentionally ignores this directory.
