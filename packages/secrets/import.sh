#!/bin/bash
set -e

# Secrets Import Script
# Imports SSH keys, GPG keys, and local config files from an encrypted tarball

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check arguments
if [ -z "$1" ]; then
    error "Usage: $0 <secrets-file.tar.gpg>"
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
    error "File not found: $INPUT_FILE"
fi

# Check for GPG
if ! command -v gpg &>/dev/null; then
    error "GPG is required but not installed. Run: brew install gnupg"
fi

TEMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

info "Importing secrets from $INPUT_FILE"
echo ""

# Decrypt with GPG
info "Decrypting archive (enter passphrase)..."
gpg --decrypt "$INPUT_FILE" > "$TEMP_DIR/secrets.tar"

# Extract tarball
cd "$TEMP_DIR"
tar -xvf secrets.tar

# Ensure directories exist
mkdir -p ~/.ssh
mkdir -p ~/.gnupg
mkdir -p ~/.config/fish
mkdir -p ~/.config/gh

# Import SSH keys
if [ -d "$TEMP_DIR/ssh" ] && [ "$(ls -A "$TEMP_DIR/ssh" 2>/dev/null)" ]; then
    info "Importing SSH keys..."
    for file in "$TEMP_DIR/ssh"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            dest="$HOME/.ssh/$filename"

            if [ -f "$dest" ]; then
                warn "  $filename already exists, skipping (backup at ${dest}.bak)"
                cp "$dest" "${dest}.bak"
            fi

            cp "$file" "$dest"

            # Set proper permissions
            if [[ "$filename" == id_* ]] && [[ "$filename" != *.pub ]]; then
                chmod 600 "$dest"
            else
                chmod 644 "$dest"
            fi

            echo "  - $filename"
        fi
    done
    success "SSH keys imported"
fi

# Import GPG keys
if [ -d "$TEMP_DIR/gpg" ] && [ "$(ls -A "$TEMP_DIR/gpg" 2>/dev/null)" ]; then
    info "Importing GPG keys..."

    if [ -f "$TEMP_DIR/gpg/secret-keys.asc" ]; then
        gpg --import "$TEMP_DIR/gpg/secret-keys.asc" 2>/dev/null || true
        echo "  - Secret keys imported"
    fi

    if [ -f "$TEMP_DIR/gpg/public-keys.asc" ]; then
        gpg --import "$TEMP_DIR/gpg/public-keys.asc" 2>/dev/null || true
        echo "  - Public keys imported"
    fi

    if [ -f "$TEMP_DIR/gpg/ownertrust.txt" ]; then
        gpg --import-ownertrust "$TEMP_DIR/gpg/ownertrust.txt" 2>/dev/null || true
        echo "  - Ownertrust imported"
    fi

    success "GPG keys imported"
fi

# Import local config files
if [ -d "$TEMP_DIR/config" ] && [ "$(ls -A "$TEMP_DIR/config" 2>/dev/null)" ]; then
    info "Importing config files..."

    # Recursively copy config files
    find "$TEMP_DIR/config" -type f | while read -r file; do
        rel_path="${file#$TEMP_DIR/config/}"
        dest="$HOME/$rel_path"

        mkdir -p "$(dirname "$dest")"

        if [ -f "$dest" ]; then
            warn "  $rel_path already exists, creating backup"
            cp "$dest" "${dest}.bak"
        fi

        cp "$file" "$dest"
        echo "  - $rel_path"
    done

    success "Config files imported"
fi

# Import environment files
if [ -d "$TEMP_DIR/env" ] && [ "$(ls -A "$TEMP_DIR/env" 2>/dev/null)" ]; then
    info "Importing environment files..."

    for file in "$TEMP_DIR/env"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            dest="$HOME/$filename"

            if [ -f "$dest" ]; then
                warn "  $filename already exists, creating backup"
                cp "$dest" "${dest}.bak"
            fi

            cp "$file" "$dest"
            echo "  - $filename"
        fi
    done

    success "Environment files imported"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
success "Secrets imported successfully!"
echo -e "${GREEN}========================================${NC}"
echo ""
info "Next steps:"
echo "  1. Verify SSH keys work: ssh -T git@github.com"
echo "  2. Trust GPG keys: gpg --edit-key <KEY_ID> and use 'trust' command"
echo "  3. Restart your shell to pick up new environment variables"
