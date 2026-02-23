#!/usr/bin/env bash
set -e

BASE_URL="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
NIX_FILE="$(dirname "$0")/../packages/claude-code.nix"

VERSION=$(curl -fsSL "$BASE_URL/latest")
echo "Latest version: $VERSION"

MANIFEST=$(curl -fsSL "$BASE_URL/$VERSION/manifest.json")

get_nix_hash() {
  local platform="$1"
  local hex=$(echo "$MANIFEST" | jq -r ".platforms.\"$platform\".checksum")
  # Convert hex sha256 to nix sri format
  echo "$hex" | xxd -r -p | base64 | awk '{print "sha256-" $0}'
}

DARWIN_ARM=$(get_nix_hash "darwin-arm64")
DARWIN_X64=$(get_nix_hash "darwin-x64")
LINUX_ARM=$(get_nix_hash "linux-arm64")
LINUX_X64=$(get_nix_hash "linux-x64")

echo "darwin-arm64: $DARWIN_ARM"
echo "darwin-x64:   $DARWIN_X64"
echo "linux-arm64:  $LINUX_ARM"
echo "linux-x64:    $LINUX_X64"

sed -i '' \
  -e "s|version = \".*\";|version = \"$VERSION\";|" \
  -e "s|\"aarch64-darwin\" = \"sha256-.*\";|\"aarch64-darwin\" = \"$DARWIN_ARM\";|" \
  -e "s|\"x86_64-darwin\"  = \"sha256-.*\";|\"x86_64-darwin\"  = \"$DARWIN_X64\";|" \
  -e "s|\"aarch64-linux\"  = \"sha256-.*\";|\"aarch64-linux\"  = \"$LINUX_ARM\";|" \
  -e "s|\"x86_64-linux\"   = \"sha256-.*\";|\"x86_64-linux\"   = \"$LINUX_X64\";|" \
  "$NIX_FILE"

echo "Updated $NIX_FILE to $VERSION"
echo "Now run: sudo darwin-rebuild switch --flake ~/dotfiles#home"
