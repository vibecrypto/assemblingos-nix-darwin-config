#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-windows-laptop}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="/etc/nixos/hardware-configuration.nix"
TARGET="$REPO_DIR/hosts/nixos/$HOST/hardware-configuration.nix"

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "Run this script from the installed NixOS laptop." >&2
  exit 1
fi

if [[ ! -f "$SOURCE" ]]; then
  echo "Missing $SOURCE. Run nixos-generate-config first." >&2
  exit 1
fi

if [[ ! -d "$(dirname "$TARGET")" ]]; then
  echo "Unknown host directory: hosts/nixos/$HOST" >&2
  exit 1
fi

if [[ -e "$TARGET" ]]; then
  echo "$TARGET already exists; refusing to overwrite it." >&2
  exit 1
fi

cp "$SOURCE" "$TARGET"

cat <<EOF
Copied generated hardware configuration to:
  $TARGET

Next:
  cd "$REPO_DIR"
  git add "hosts/nixos/$HOST/hardware-configuration.nix"
  nix flake show
  sudo nixos-rebuild build --flake ".#$HOST"

Only after the build succeeds:
  sudo nixos-rebuild switch --flake ".#$HOST"
EOF
