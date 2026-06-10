#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-AssemblingOS-MacBook-Pro}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap is only for macOS/Darwin." >&2
  exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "Nix is not installed. Follow docs/install-macos.md first." >&2
  exit 1
fi

cd "$REPO_DIR"

echo "Validating AssemblingOS flake..."
nix flake show --no-write-lock-file

echo "Building Darwin host: $HOST"
if command -v darwin-rebuild >/dev/null 2>&1; then
  darwin-rebuild build --flake ".#$HOST"
else
  nix run nix-darwin/master#darwin-rebuild -- build --flake ".#$HOST"
fi

cat <<EOF

Build completed. Review the host values and Git diff before applying.

Apply only when ready:
  sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ".#$HOST"

After nix-darwin is installed:
  sudo darwin-rebuild switch --flake ".#$HOST"
EOF
