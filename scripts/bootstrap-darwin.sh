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

current_user="$(id -un)"
current_host="$(scutil --get LocalHostName 2>/dev/null || hostname)"
case "$(uname -m)" in
  arm64) current_platform="aarch64-darwin" ;;
  x86_64) current_platform="x86_64-darwin" ;;
  *)
    echo "Unsupported macOS architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

macos_major="$(sw_vers -productVersion | cut -d. -f1)"
if (( macos_major < 14 )); then
  echo "macOS 14 or newer is required by the declared cmux cask." >&2
  echo "Upgrade macOS or remove cmux before building this host." >&2
  exit 1
fi

target_user="$(nix eval --raw ".#darwinConfigurations.${HOST}.config.system.primaryUser")"
target_platform="$(nix eval --raw ".#darwinConfigurations.${HOST}.config.nixpkgs.hostPlatform.system")"
target_host="$(nix eval --raw ".#darwinConfigurations.${HOST}.config.networking.hostName")"

printf 'Detected: user=%s platform=%s host=%s\n' \
  "$current_user" "$current_platform" "$current_host"
printf 'Target:   user=%s platform=%s host=%s\n' \
  "$target_user" "$target_platform" "$target_host"

if [[ "$current_user" != "$target_user" ]]; then
  echo "User mismatch. Update the host definition before building." >&2
  exit 1
fi

if [[ "$current_platform" != "$target_platform" ]]; then
  echo "Platform mismatch. Update the host definition before building." >&2
  exit 1
fi

if [[ -n "$(git status --short)" ]]; then
  echo "Warning: the repository is dirty; the build includes local changes." >&2
fi

echo "Validating AssemblingOS flake..."
nix flake show --no-write-lock-file

echo "Building Darwin host: $HOST"
nix build ".#darwinConfigurations.${HOST}.system" --no-link

cat <<EOF

Build completed. Review the host values and Git diff before applying.

Apply only when ready:
  sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ".#$HOST"

After nix-darwin is installed:
  sudo darwin-rebuild switch --flake ".#$HOST"
EOF
