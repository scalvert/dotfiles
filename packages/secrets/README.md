# Secrets Management

Tools for securely exporting and importing secrets between machines.

## What Gets Exported

- **SSH Keys**: `~/.ssh/id_*`, `~/.ssh/config`, `~/.ssh/known_hosts`
- **GPG Keys**: Private keys, public keys, ownertrust
- **Config Files**: `.gitconfig.local`, `.zshrc.local`, `.npmrc`, `local.fish`, etc.
- **Environment Files**: `.env`, `.envrc`

## Usage

### Export Secrets

Export all secrets to an encrypted tarball:

```bash
mise run secrets:export
# Creates: secrets-YYYYMMDD.tar.gpg
```

Or specify a custom output file:

```bash
mise run secrets:export -- my-secrets.tar.gpg
```

### Import Secrets

Import secrets on a new machine:

```bash
mise run secrets:import -- secrets-20260201.tar.gpg
```

## Security

- All exports are encrypted with AES256 using GPG symmetric encryption
- You'll be prompted for a passphrase during export/import
- Keep the passphrase secure - it's the only way to decrypt the archive
- The archive is portable and can be transferred via USB, cloud storage, etc.

## Requirements

- `gpg` (GNU Privacy Guard) must be installed
  - macOS: `brew install gnupg`
  - Linux: `apt install gnupg` or `dnf install gnupg2`

## Files Not Exported

The following are intentionally NOT exported:

- `.ssh/authorized_keys` (machine-specific)
- SSH agent sockets
- Temporary files
- Application-specific caches

## Manual Steps After Import

1. **Verify SSH**: `ssh -T git@github.com`
2. **Trust GPG Keys**: `gpg --edit-key <KEY_ID>` then `trust`
3. **Restart Shell**: `exec fish` or open a new terminal
