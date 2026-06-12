#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OBS_TEMPLATE="$REPO_DIR/creator/obs/basic.ini.template"
EVO_TEMPLATE="$REPO_DIR/creator/evo/assemblingos-creator.xml"
OBS_TARGET="$HOME/Library/Application Support/obs-studio/basic/profiles/AssemblingOS Creator/basic.ini"
EVO_TARGET="$HOME/Library/Application Support/Audient/EVO/presets/assemblingos-creator.xml"

apply=false
force=false

usage() {
  cat <<'EOF'
Prepare the AssemblingOS creator profile on macOS.

Usage:
  bash scripts/bootstrap-creator.sh
  bash scripts/bootstrap-creator.sh --apply
  bash scripts/bootstrap-creator.sh --apply --force

The default is a dry run. --apply writes the portable OBS profile and copies
the EVO8 preset. It never copies stream keys, account tokens, WebSocket
passwords, display UUIDs, or hardware serial numbers.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --apply) apply=true ;;
    --force) force=true ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$arg" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This creator profile currently targets macOS.\n' >&2
  exit 1
fi

if pgrep -x OBS >/dev/null 2>&1; then
  printf 'Close OBS before installing or updating its profile.\n' >&2
  exit 1
fi

printf 'AssemblingOS creator bootstrap\n'
printf 'OBS profile: ~/Library/Application Support/obs-studio/basic/profiles/AssemblingOS Creator/basic.ini\n'
printf 'EVO8 preset: ~/Library/Application Support/Audient/EVO/presets/assemblingos-creator.xml\n'

if ! $apply; then
  cat <<'EOF'

Dry run only. No files were changed.

Apply:
  bash scripts/bootstrap-creator.sh --apply
EOF
  exit 0
fi

for target in "$OBS_TARGET" "$EVO_TARGET"; do
  if [[ -e "$target" ]] && ! $force; then
    printf 'Refusing to overwrite existing file: %s\n' "$target" >&2
    printf 'Review it first, then rerun with --apply --force if appropriate.\n' >&2
    exit 1
  fi
done

mkdir -p "$(dirname "$OBS_TARGET")" "$(dirname "$EVO_TARGET")" "$HOME/Movies/OBS"

sed "s|__HOME__|$HOME|g" "$OBS_TEMPLATE" > "$OBS_TARGET"
cp "$EVO_TEMPLATE" "$EVO_TARGET"

cat <<'EOF'

Portable creator files installed.

One-time bindings that macOS or the hardware vendor must handle:
1. OBS Studio -> Review App Permissions:
   enable Screen Recording, Microphone, and Accessibility.
2. Audio MIDI Setup:
   set EVO8 to 48,000 Hz to match OBS.
3. EVO:
   load the "assemblingos-creator" preset, connect the Shure microphone to
   input 1, and enable 48 V only if the exact microphone or inline preamp
   requires it.
4. OBS:
   capture the screen and select the output of the AI voice-processing layer
   as the microphone source. EVO8 remains the physical Shure input.
5. Run:
   bash scripts/creator-doctor.sh

Secrets and machine-specific display/device identifiers were intentionally not copied.
EOF
