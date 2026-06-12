#!/usr/bin/env bash
set -euo pipefail

OBS_DIR="$HOME/Library/Application Support/obs-studio"
OBS_PROFILE="$OBS_DIR/basic/profiles/AssemblingOS Creator/basic.ini"
OBS_LOG_DIR="$OBS_DIR/logs"
EVO_PRESET="$HOME/Library/Application Support/Audient/EVO/presets/assemblingos-creator.xml"

warnings=0
failures=0
public_output=false

usage() {
  cat <<'EOF'
Inspect the AssemblingOS creator workstation without changing it.

Usage:
  bash scripts/creator-doctor.sh
  bash scripts/creator-doctor.sh --public

--public omits machine-identifying details so the output is safer to share.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --public) public_output=true ;;
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

app_version() {
  local app="$1"
  /usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' \
    "$app/Contents/Info.plist" 2>/dev/null \
    || /usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' \
      "$app/Contents/Info.plist" 2>/dev/null \
    || printf 'unknown'
}

printf 'AssemblingOS creator doctor\n'
if $public_output; then
  printf 'Architecture: %s | Public output: enabled\n\n' "$(uname -m)"
else
  printf 'Host: %s | Architecture: %s\n\n' "$(scutil --get LocalHostName 2>/dev/null || hostname)" "$(uname -m)"
fi

if [[ "$(uname -s)" != "Darwin" ]]; then
  fail "This creator profile currently targets macOS."
fi

for app in \
  "/Applications/OBS.app" \
  "/Applications/EVO.app" \
  "/Applications/Blackmagic ATEM Switchers/ATEM Software Control.app"; do
  if [[ -d "$app" ]]; then
    ok "$(basename "$app") $(app_version "$app")"
  else
    fail "Missing application: $app"
  fi
done

usb_tree="$(ioreg -p IOUSB -l -w 0 2>/dev/null || true)"

if grep -q '"USB Product Name" = "EVO8"' <<<"$usb_tree"; then
  ok "EVO8 is connected over USB."
else
  warn "EVO8 is not currently detected over USB."
fi

if grep -q '"USB Product Name" = "ATEM Mini Extreme ISO"' <<<"$usb_tree"; then
  ok "ATEM Mini Extreme ISO is connected over USB."
else
  warn "ATEM Mini Extreme ISO is not currently detected over USB."
fi

latest_log="$(
  find "$OBS_LOG_DIR" -maxdepth 1 -type f -name '*.txt' -print 2>/dev/null \
    | sort \
    | tail -n 1 \
    || true
)"

if [[ -f "$OBS_PROFILE" ]]; then
  ok "Portable OBS profile is installed."

  if grep -q '^SampleRate=48000$' "$OBS_PROFILE"; then
    ok "OBS profile uses 48 kHz audio."
  else
    fail "OBS profile is not configured for 48 kHz audio."
  fi

  if grep -q '^OutputCX=1920$' "$OBS_PROFILE" \
    && grep -q '^OutputCY=1080$' "$OBS_PROFILE" \
    && grep -q '^FPSCommon=60$' "$OBS_PROFILE"; then
    ok "OBS profile uses 1080p60."
  else
    warn "OBS profile is not configured for 1080p60."
  fi

  if grep -q '^StreamEncoder=apple_h264$' "$OBS_PROFILE" \
    && grep -q '^RecEncoder=apple_h264$' "$OBS_PROFILE"; then
    ok "OBS profile uses Apple hardware H.264 encoding."
  else
    warn "OBS profile is not using Apple H.264 for both stream and recording."
  fi
else
  warn "Portable OBS profile is not installed. Run scripts/bootstrap-creator.sh --apply."
fi

if [[ -n "$latest_log" ]]; then
  if $public_output; then
    ok "Found the latest OBS diagnostic log."
  else
    ok "Found OBS log: $(basename "$latest_log")"
  fi

  evo_rate="$(
    sed -nE "s/.*coreaudio: Device 'EVO8' \\[([0-9]+) Hz\\] initialized.*/\\1/p" \
      "$latest_log" \
      | tail -n 1
  )"
  if [[ "$evo_rate" == "48000" ]]; then
    ok "OBS initialized EVO8 at 48 kHz."
  elif [[ -n "$evo_rate" ]]; then
    warn "OBS initialized EVO8 at ${evo_rate} Hz; use 48 kHz to match the OBS profile."
  else
    warn "The latest OBS log did not confirm an EVO8 sample rate."
  fi

  if grep -q 'Permission for audio device access granted' "$latest_log"; then
    ok "OBS microphone/audio permission is granted."
  else
    warn "OBS audio permission was not confirmed in the latest log."
  fi

  if grep -q 'Permission for screen capture granted' "$latest_log"; then
    ok "OBS screen recording permission is granted."
  else
    warn "OBS screen recording permission was not confirmed."
  fi

  if grep -q 'Permission for video device access granted' "$latest_log"; then
    ok "OBS camera permission is granted."
  else
    warn "OBS camera permission is missing; ATEM video capture cannot be considered ready."
  fi

  if grep -q 'Permission for input monitoring granted' "$latest_log"; then
    ok "OBS input monitoring/accessibility permission is granted."
  else
    warn "OBS input monitoring permission is missing; global hotkeys may not work."
  fi

  if grep -Eq 'AudioQueueEnqueueBuffer failed|device .* disconnected or changed|failed to find device uid' "$latest_log"; then
    warn "Latest OBS run contains audio device/reconnection errors."
  else
    ok "Latest OBS log has no recognized audio reconnection errors."
  fi
else
  warn "No OBS log was found."
fi

if [[ -f "$EVO_PRESET" ]]; then
  ok "AssemblingOS EVO8 preset is installed."
else
  warn "AssemblingOS EVO8 preset is not installed."
fi

if [[ -f "$OBS_DIR/plugin_config/obs-websocket/config.json" ]]; then
  if jq -e '(.server_password // "") | length > 0' \
    "$OBS_DIR/plugin_config/obs-websocket/config.json" >/dev/null 2>&1; then
    ok "OBS WebSocket has a password; it remains local and is not copied by the bootstrap."
  else
    warn "OBS WebSocket does not appear to have a password."
  fi
fi

printf '\nSummary: %d warning(s), %d failure(s)\n' "$warnings" "$failures"

if (( failures > 0 )); then
  exit 1
fi
