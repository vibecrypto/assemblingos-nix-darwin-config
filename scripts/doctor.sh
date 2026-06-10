#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

echo "AssemblingOS doctor"
echo "OS: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "User: $(id -un)"
echo

for command in nix git; do
  if command -v "$command" >/dev/null 2>&1; then
    echo "[ok] $command: $(command -v "$command")"
  else
    echo "[missing] $command"
  fi
done

echo
echo "Git status:"
git status --short

echo
echo "Flake outputs:"
nix flake show --no-write-lock-file
