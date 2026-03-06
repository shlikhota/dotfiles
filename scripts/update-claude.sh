#!/usr/bin/env bash
set -e

NPM_URL="https://registry.npmjs.org/@anthropic-ai/claude-code/latest"
NIX_FILE="$(dirname "$0")/../packages/claude-code.nix"

METADATA=$(curl -fsSL "$NPM_URL")
VERSION=$(echo "$METADATA" | jq -r '.version')
HASH=$(echo "$METADATA" | jq -r '.dist.integrity')

echo "Latest version: $VERSION"
echo "Hash: $HASH"

sed -i '' \
  -e "s|version = \".*\";|version = \"$VERSION\";|" \
  -e "s|hash = \"sha512-.*\";|hash = \"$HASH\";|" \
  "$NIX_FILE"

echo "Updated $NIX_FILE to $VERSION"
echo "Now run: sudo darwin-rebuild switch --flake ~/dotfiles#home"
