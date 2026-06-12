# AssemblingOS Project Memory

Last reviewed: June 12, 2026

Read this file first when continuing AssemblingOS from a new agent, session, or
machine. The Git repository is the portable source of truth. Chat memory is
helpful but secondary.

## Project Purpose

AssemblingOS is a Nix-centered reproducible environment for macOS/Darwin and
NixOS.

The first product direction is:

> Help a non-Nix-expert turn a Mac into a private, reproducible AI and
> development workstation while retaining ownership of the configuration.

The longer-term direction adds:

- shared Darwin and NixOS user configuration
- project-local development environments
- agent-first tool evaluation
- local AI and creator profiles
- controlled agent execution
- guided installation, diagnosis, rollback, and multi-machine replication

## Repositories

System repository:

```text
git@github.com:vibecrypto/assemblingos-nix-darwin-config.git
```

Expected local path:

```text
~/nix-darwin-config
```

Agent skills are maintained separately so they remain agent-agnostic:

```text
assemblingos-agent-skills
```

## Current Implemented Hosts

Darwin:

```text
DRs-MacBook-Pro
AssemblingOS-MacBook-Pro
```

NixOS:

```text
assemblingos-vm
windows-laptop
```

`windows-laptop` is intentionally conditional. It appears only after the real
NixOS installer-generated file exists at:

```text
hosts/nixos/windows-laptop/hardware-configuration.nix
```

Do not create fake UUIDs, filesystems, drivers, or hardware configuration for
the physical laptop.

## Implemented Architecture

- `flake.nix`: host factories and flake outputs
- `modules/shared/`: packages shared by Darwin and NixOS
- `modules/darwin/`: macOS-specific configuration and applications
- `modules/nixos/`: NixOS base and GNOME desktop
- `modules/home/`: shared Home Manager user configuration
- `hosts/nixos/`: physical NixOS host configuration
- `templates/node/`: Node 22 and pnpm project template
- `templates/python/`: Python 3.12 and uv project template
- `labs/`: experimental applications such as Herdr and Odysseus
- `scripts/`: build, diagnosis, and hardware-import helpers
- `creator/`: portable OBS and EVO creator-profile assets
- `docs/`: installation, migration, placement, and safety documentation

## Current Shared User Configuration

Home Manager currently manages a deliberately small baseline:

- Git
- GitHub CLI
- Zsh
- completion
- autosuggestions
- syntax highlighting
- direnv
- nix-direnv

Home Manager is integrated into both nix-darwin and NixOS.

## Current Shared System Tools

- Neovim and Emacs
- wget, fzf, ripgrep, fd, and jq
- Codex, OpenCode, Claude Code, and Pi
- Lua language server, ty, and Ruff

Darwin separately includes macOS applications and Homebrew casks.

## Labs

Herdr:

```text
labs/herdr
```

Odysseus:

```text
labs/odysseus
```

Odysseus runtime data, `.venv`, application clone, ChromaDB data, models, and
caches are local state and are not the portable source of truth.

## Creator Profile

The macOS creator profile lives in:

```text
creator/
docs/creator-workstation.md
scripts/bootstrap-creator.sh
scripts/creator-doctor.sh
```

It reproduces the OBS baseline and EVO8 preset for a screen-only workflow with
a Shure microphone connected to EVO8 and an optional AI voice-processing layer.
It excludes stream keys, tokens, WebSocket passwords, hardware serial numbers,
display UUIDs, and other machine-specific identifiers. Audio routing and macOS
permissions remain explicit one-time bindings on each Mac.

## Core Placement Rules

```text
Used by the machine
  -> nix-darwin or NixOS

Used by the person everywhere
  -> Home Manager

Used by one project
  -> project flake and nix develop

Being evaluated
  -> lab

Needed once
  -> nix shell or nix run

Proprietary hardware integration
  -> Homebrew or documented manual installer

Untrusted autonomous execution
  -> container or VM, not only nix develop
```

`nix develop` provides dependency and version isolation. It is not a security
sandbox.

## Tool Selection Principles

- Check whether a tool is already installed or declared.
- Prefer nixpkgs when quality is comparable.
- Prefer official upstream flakes for suitable CLI/developer tools not in
  nixpkgs.
- Prefer cross-platform Darwin/Linux tools.
- Prefer agent-first interfaces: CLI/API, non-interactive behavior, predictable
  output, clear exit codes, and good documentation.
- Keep experimental tools in labs.
- Document manual vendor installations.
- Ask before installation or system changes.

## Git And Change Rules

- Check `git status` before editing.
- Do not overwrite unrelated user changes.
- Make focused changes.
- Validate before committing.
- Commit every verified logical change.
- Push portable configuration to the private remote.
- Build before switch.
- Never run `darwin-rebuild switch` or `nixos-rebuild switch` without explicit
  user approval.
- Never automate disk repartitioning.

## Validation Evidence

The first reproducible version was validated with:

- `nix flake check --no-build`
- Darwin build for `DRs-MacBook-Pro`
- Darwin build for `AssemblingOS-MacBook-Pro`
- NixOS VM evaluation
- temporary evaluation of the conditional physical NixOS host
- Node template smoke test using Node 22
- Python template smoke test using Python 3.12 and uv

No system `switch` was run while preparing this version.

## Installation Entry Points

Architecture:

```text
docs/first-version-architecture.md
```

Clean Mac:

```text
docs/install-macos.md
```

Windows dual-boot preparation:

```text
docs/windows-dual-boot-preflight.md
```

NixOS after installation:

```text
docs/install-nixos.md
```

Machine details to collect:

```text
docs/host-inventory.md
```

Agent prompts:

```text
docs/agent-handoff-prompts.md
```

## Information Still Needed

Second Mac:

- `whoami`
- `uname -m`
- `scutil --get LocalHostName`
- desired host profile

Windows/NixOS laptop:

- manufacturer and exact model
- CPU and GPU
- RAM
- disk layout
- Wi-Fi chipset
- UEFI state
- BitLocker/device-encryption state
- desired username and hostname
- GNOME or KDE preference

## Recommended Next Steps

1. Complete `docs/host-inventory.md`.
2. Install and validate the second Mac using `docs/install-macos.md`.
3. Do not install NixOS until backups, recovery media, BitLocker information,
   and partition planning are complete.
4. Test the NixOS live environment and hardware.
5. Install NixOS beside Windows.
6. Import the generated hardware configuration using
   `scripts/prepare-nixos-host.sh`.
7. Build before switching.
8. Commit the verified physical host configuration.
9. Test one Node and one Python project on both systems.

## New Agent Startup Contract

When an agent receives this repository:

1. Read this file and `README.md`.
2. Read the installation document for the current platform.
3. Run read-only inspection first.
4. Summarize the detected machine, repository state, target host, and next safe
   step.
5. Identify decisions requiring user confirmation.
6. Do not install, edit, switch, repartition, or commit until the user confirms.

This contract applies to Codex, Claude, OpenCode, Pi, and other agents.
