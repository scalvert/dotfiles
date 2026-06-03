#!/bin/bash
set -e

# Secrets Export Script
# Exports SSH keys, GPG keys, and local config files to an encrypted tarball

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

# Configuration
DATE=$(date +%Y%m%d)
OUTPUT_FILE="${1:-secrets-${DATE}.tar.gpg}"
TEMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Check for GPG
if ! command -v gpg &>/dev/null; then
    error "GPG is required but not installed. Run: brew install gnupg"
fi

info "Exporting secrets to $OUTPUT_FILE"
echo ""

# Create directory structure in temp
mkdir -p "$TEMP_DIR/ssh"
mkdir -p "$TEMP_DIR/gpg"
mkdir -p "$TEMP_DIR/config"
mkdir -p "$TEMP_DIR/env"

# Export SSH keys
info "Exporting SSH keys..."
if [ -d ~/.ssh ]; then
    for file in ~/.ssh/id_* ~/.ssh/config ~/.ssh/known_hosts; do
        if [ -f "$file" ]; then
            cp "$file" "$TEMP_DIR/ssh/"
            echo "  - $(basename "$file")"
        fi
    done
    success "SSH keys exported"
else
    warn "No ~/.ssh directory found"
fi

# Export GPG keys
info "Exporting GPG keys..."
if command -v gpg &>/dev/null && [ -d ~/.gnupg ]; then
    # Export secret keys
    if gpg --list-secret-keys --keyid-format LONG 2>/dev/null | grep -q sec; then
        gpg --armor --export-secret-keys > "$TEMP_DIR/gpg/secret-keys.asc" 2>/dev/null || true
        gpg --armor --export > "$TEMP_DIR/gpg/public-keys.asc" 2>/dev/null || true
        gpg --export-ownertrust > "$TEMP_DIR/gpg/ownertrust.txt" 2>/dev/null || true
        echo "  - secret-keys.asc"
        echo "  - public-keys.asc"
        echo "  - ownertrust.txt"
        success "GPG keys exported"
    else
        warn "No GPG secret keys found"
    fi
else
    warn "GPG not configured"
fi

# Export local config files
info "Exporting local config files..."
LOCAL_FILES=(
    "$HOME/.gitconfig.local"
    "$HOME/.zshrc.local"
    "$HOME/.npmrc"
    "$HOME/.config/fish/local.fish"
    "$HOME/.config/gh/hosts.yml"
)

for file in "${LOCAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        # Preserve directory structure relative to HOME
        rel_path="${file#$HOME/}"
        mkdir -p "$TEMP_DIR/config/$(dirname "$rel_path")"
        cp "$file" "$TEMP_DIR/config/$rel_path"
        echo "  - $rel_path"
    fi
done
success "Config files exported"

# Export environment files
info "Exporting environment files..."
ENV_FILES=(
    "$HOME/.env"
    "$HOME/.envrc"
)

for file in "${ENV_FILES[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$TEMP_DIR/env/"
        echo "  - $(basename "$file")"
    fi
done
success "Environment files exported"

# Create tarball and encrypt with GPG
info "Creating encrypted archive..."
echo ""

cd "$TEMP_DIR"
tar -cvf secrets.tar ssh gpg config env 2>/dev/null

# Encrypt with GPG (symmetric)
echo ""
info "Encrypting with GPG (you will be prompted for a passphrase)..."
gpg --symmetric --cipher-algo AES256 -o "../$OUTPUT_FILE" secrets.tar

cd - >/dev/null
mv "$TEMP_DIR/../$OUTPUT_FILE" "$OUTPUT_FILE" 2>/dev/null || true

echo ""
echo -e "${GREEN}========================================${NC}"
success "Secrets exported to: $OUTPUT_FILE"
echo -e "${GREEN}========================================${NC}"
echo ""
info "To import on a new machine, run:"
echo "  mise run secrets:import -- $OUTPUT_FILE"
echo ""
warn "Keep this file secure and remember your passphrase!"
