# Creator Workstation

This profile makes the software and baseline recording configuration portable
without copying secrets or pretending that physical hardware identifiers are
the same on every Mac.

## Included

- OBS Studio declared through nix-homebrew
- FFmpeg and FFprobe declared through Nix
- OBS profile for:
  - 1920x1080 at 60 fps
  - 48 kHz stereo audio
  - Apple hardware H.264 encoding
  - hybrid MOV recording to `~/Movies/OBS`
- EVO8 mixer preset
- read-only creator diagnostics using USB state and OBS logs

## Install On Another Mac

After applying the AssemblingOS Darwin host:

```bash
cd ~/nix-darwin-config
bash scripts/bootstrap-creator.sh
bash scripts/bootstrap-creator.sh --apply
bash scripts/creator-doctor.sh
```

The first command is a dry run.

For a terminal screenshot that omits the hostname and log filename:

```bash
bash scripts/creator-doctor.sh --public
```

## One-Time Hardware Bindings

These cannot be safely copied between machines:

1. Grant OBS Screen Recording, Camera, Microphone, and Accessibility
   permissions from `OBS Studio -> Review App Permissions`.
2. In Audio MIDI Setup, set EVO8 to 48,000 Hz.
3. In EVO, load `assemblingos-creator` only after confirming the microphone on
   input 1 requires 48 V phantom power.
4. In OBS, select EVO8 as the microphone.
5. In OBS, add ATEM Mini Extreme ISO as the video capture device.
6. Select the screen or window to capture on that Mac.

macOS permissions, display UUIDs, USB location-derived device IDs, stream keys,
account tokens, and OBS WebSocket passwords are intentionally excluded.

## Current Diagnostic Findings

On June 12, 2026:

- OBS 32.1.1, EVO 4.4.0, and ATEM Software Control were installed.
- EVO8 and ATEM Mini Extreme ISO were detected over USB.
- OBS audio and screen recording permissions were granted.
- OBS camera and input-monitoring permissions were not granted.
- OBS used 48 kHz, but EVO8 was initialized at 96 kHz.
- The OBS log recorded EVO8 device lookup/reconnection errors and fallbacks to
  Voicemod and the MacBook microphone.
- OBS WebSocket had authentication enabled; its password is not portable and
  must never be committed.

The system should not be called ready for live production until
`scripts/creator-doctor.sh` reports no failures and the remaining warnings have
been reviewed.

## Audio Quality Boundary

The doctor verifies routing, sample rate, device stability, and application
configuration. It does not judge room acoustics, clipping, noise floor,
compression, EQ, or voice quality without a recording sample.
