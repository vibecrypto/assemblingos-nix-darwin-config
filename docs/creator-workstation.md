# Creator Workstation

This profile makes the software and baseline recording configuration portable
without copying secrets or pretending that physical hardware identifiers are
the same on every Mac.

The current production path is screen-only:

```text
Shure microphone -> EVO8 -> AI voice-processing layer -> OBS
Screen capture -------------------------------------------> OBS
```

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

1. Grant OBS Screen Recording, Microphone, and Accessibility permissions from
   `OBS Studio -> Review App Permissions`. Camera permission is intentionally
   not required for the screen-only workflow.
2. In Audio MIDI Setup, set EVO8 to 48,000 Hz.
3. Connect the Shure microphone to EVO8 input 1 and load
   `assemblingos-creator`. Enable 48 V only if that exact microphone or an
   inline preamp requires it.
4. Configure the voice-processing application to receive EVO8 and provide its
   processed virtual output to OBS.
5. In OBS, select the processed voice output as the microphone source.
6. Select the screen or window to capture on that Mac.

ATEM remains installed and detectable for future capture-card use, but it is
not required for the current screen-only workflow. Run
`scripts/creator-doctor.sh --with-camera` only when adding camera or ATEM video.

macOS permissions, display UUIDs, USB location-derived device IDs, stream keys,
account tokens, and OBS WebSocket passwords are intentionally excluded.

## Current Diagnostic Findings

On June 12, 2026:

- OBS 32.1.1, EVO 4.4.0, and ATEM Software Control were installed.
- EVO8 and ATEM Mini Extreme ISO were detected over USB.
- OBS audio and screen recording permissions were granted.
- OBS input-monitoring permission was not granted. Camera permission is not
  required for the current screen-only workflow.
- OBS used 48 kHz, but EVO8 was initialized at 96 kHz.
- The OBS log recorded EVO8 device lookup/reconnection errors and fallbacks to
  the AI voice-processing layer and the MacBook microphone.
- OBS WebSocket had authentication enabled; its password is not portable and
  must never be committed.

The system should not be called ready for live production until
`scripts/creator-doctor.sh` reports no failures and the remaining warnings have
been reviewed.

## Audio Quality Boundary

The doctor verifies routing, sample rate, device stability, and application
configuration. It does not judge room acoustics, clipping, noise floor,
compression, EQ, or voice quality without a recording sample.
