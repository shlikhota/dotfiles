#!/usr/bin/env bash
set -e

NIX_FILE="$(dirname "$0")/../packages/claude-code.nix"

# Get latest version from wrapper package
WRAPPER_URL="https://registry.npmjs.org/@anthropic-ai/claude-code/latest"
METADATA=$(curl -fsSL "$WRAPPER_URL")
VERSION=$(echo "$METADATA" | jq -r '.version')

echo "Latest version: $VERSION"
echo ""

# Platform mapping: nix system -> npm platform suffix
declare -A PLATFORMS=(
  ["aarch64-darwin"]="darwin-arm64"
  ["x86_64-darwin"]="darwin-x64"
  ["aarch64-linux"]="linux-arm64"
  ["x86_64-linux"]="linux-x64"
)

# Fetch hashes for all platforms
declare -A HASHES
for system in "${!PLATFORMS[@]}"; do
  platform="${PLATFORMS[$system]}"
  pkg_url="https://registry.npmjs.org/@anthropic-ai%2fclaude-code-${platform}/${VERSION}"

  pkg_metadata=$(curl -fsSL "$pkg_url" 2>/dev/null || echo "")

  if [[ -n "$pkg_metadata" ]]; then
    hash=$(echo "$pkg_metadata" | jq -r '.dist.integrity // empty')
    if [[ -n "$hash" && "$hash" != "null" ]]; then
      HASHES[$system]="$hash"
      echo "✓ ${system}: ${hash}"
    else
      echo "✗ ${system}: no hash"
    fi
  else
    echo "✗ ${system}: package not found"
  fi
done

# Update version in nix file
sed -i '' \
  -e "s|version = \".*\";|version = \"${VERSION}\";|" \
  "$NIX_FILE"

# Update hashes in nix file - replace each hash line
for system in "${!HASHES[@]}"; do
  old_pattern="${system} = \"sha512-[^\"]*\";"
  new_value="${system} = \"${HASHES[$system]}\";"
  sed -i '' \
    -e "s|${old_pattern}|${new_value}|" \
    "$NIX_FILE"
done

echo ""
echo "Updated $NIX_FILE to $VERSION"
echo "Now run: sudo darwin-rebuild switch --flake ~/dotfiles#home"
