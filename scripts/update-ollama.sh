#!/usr/bin/env bash
set -e

GITHUB_API="https://api.github.com/repos/ollama/ollama/releases/latest"
NIX_FILE="$(dirname "$0")/../packages/ollama.nix"

METADATA=$(curl -fsSL "$GITHUB_API")
VERSION=$(echo "$METADATA" | jq -r '.tag_name' | sed 's/^v//')
DOWNLOAD_URL="https://github.com/ollama/ollama/releases/download/v${VERSION}/ollama-darwin.tgz"

echo "Latest version: $VERSION"
echo "Fetching hash..."

RAW_HASH=$(nix-prefetch-url --type sha256 "$DOWNLOAD_URL" 2>/dev/null)
HASH=$(nix hash convert --hash-algo sha256 --to sri "$RAW_HASH")

echo "Hash: $HASH"

sed -i '' \
  -e "s|version = \".*\";|version = \"$VERSION\";|" \
  -e "s|hash = \"sha256-.*\";|hash = \"$HASH\";|" \
  "$NIX_FILE"

echo "Updated $NIX_FILE to $VERSION"
echo "Now run: sudo darwin-rebuild switch --flake ~/dotfiles#home"
