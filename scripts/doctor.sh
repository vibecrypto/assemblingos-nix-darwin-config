#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

warnings=0
failures=0

ok() {
  printf '[ok] %s\n' "$1"
}

warn() {
  printf '[warn] %s\n' "$1"
  warnings=$((warnings + 1))
}

fail() {
  printf '[fail] %s\n' "$1"
  failures=$((failures + 1))
}

check_command() {
  local command_name="$1"
  local required="${2:-false}"

  if command -v "$command_name" >/dev/null 2>&1; then
    ok "$command_name: $(command -v "$command_name")"
  elif [[ "$required" == "true" ]]; then
    fail "Missing required command: $command_name"
  else
    warn "Missing declared command: $command_name"
  fi
}

check_app() {
  local app_name="$1"
  local found=false

  for root in "/Applications" "/Applications/Nix Apps" "$HOME/Applications"; do
    if [[ -d "$root/$app_name" ]]; then
      ok "$app_name"
      found=true
      break
    fi
  done

  if ! $found; then
    warn "Application not found: $app_name"
  fi
}

echo "AssemblingOS doctor"
echo "OS: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "User: $(id -un)"
echo "Host: $(scutil --get LocalHostName 2>/dev/null || hostname)"
echo

for command_name in nix git darwin-rebuild; do
  check_command "$command_name" true
done

for command_name in \
  home-manager \
  gh \
  codex \
  opencode \
  claude \
  pi \
  nvim \
  emacs \
  rg \
  fd \
  jq \
  direnv \
  ffmpeg; do
  check_command "$command_name"
done

echo
echo "Git:"
echo "Branch: $(git branch --show-current)"
echo "Latest: $(git log -1 --oneline --decorate)"
echo "Remote:"
git remote -v
echo "Status:"
git status --short

if upstream="$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)"; then
  read -r behind ahead < <(git rev-list --left-right --count "$upstream...HEAD")
  if [[ "$behind" == "0" && "$ahead" == "0" ]]; then
    ok "HEAD matches $upstream in the local Git view."
  else
    warn "Git differs from $upstream: behind=$behind ahead=$ahead"
  fi
else
  warn "Current branch has no upstream."
fi

git_name="$(git config --global --get user.name || true)"
git_email="$(git config --global --get user.email || true)"
if [[ -n "$git_name" && -n "$git_email" ]]; then
  ok "Git author identity: $git_name <$git_email>"
else
  warn "Global Git author name/email are not fully configured."
fi

echo
echo "Flake outputs:"
if nix flake show --no-write-lock-file; then
  ok "Flake evaluation completed."
else
  fail "Flake evaluation failed."
fi

echo
echo "Applications:"
for app_name in \
  "Ghostty.app" \
  "AeroSpace.app" \
  "Raycast.app" \
  "Obsidian.app" \
  "Google Chrome.app" \
  "Keymapp.app" \
  "WhatsApp.app" \
  "OBS.app" \
  "TradingView.app" \
  "cmux.app" \
  "Codex.app"; do
  check_app "$app_name"
done

echo
echo "Personal Codex skills:"
for skill_name in \
  assemblingos-tool-evaluator \
  clear-english-communication-coach \
  skool-message-assistant; do
  skill_path="$HOME/.codex/skills/$skill_name/SKILL.md"
  if [[ -f "$skill_path" ]]; then
    ok "$skill_name"
  else
    warn "Missing personal skill: $skill_name"
  fi
done

printf '\nSummary: %d warning(s), %d failure(s)\n' "$warnings" "$failures"

if (( failures > 0 )); then
  exit 1
fi
