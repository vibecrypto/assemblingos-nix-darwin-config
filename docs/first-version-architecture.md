# First Reproducible Version

This version proves that one Git repository can reproduce the shared
AssemblingOS environment on another Mac and provide the same core user and
project tools on NixOS.

## Architecture

```text
Git repository
  |
  +-- Darwin host: DRs-MacBook-Pro
  +-- Darwin host: AssemblingOS
  +-- NixOS validation VM: assemblingos-vm
  +-- NixOS physical host: windows-laptop
  |
  +-- Shared system packages
  +-- Shared Home Manager user configuration
  +-- Darwin-only applications
  +-- Node and Python project templates
  +-- Experimental labs
```

## What Is Shared

- Git and GitHub CLI
- Neovim and Emacs
- shell utilities
- Codex, OpenCode, Claude Code, and Pi
- developer tooling
- Zsh, direnv, and user configuration through Home Manager
- project templates

## What Remains Platform-Specific

Darwin:

- Ghostty
- Aerospace
- Raycast
- macOS applications
- Homebrew casks
- proprietary vendor installers

NixOS:

- bootloader
- generated hardware configuration
- NetworkManager
- GNOME desktop
- Linux hardware and driver modules

## Why The Physical NixOS Host Is Conditional

NixOS generates a hardware configuration from the actual laptop. The repository
does not invent disk UUIDs, filesystem mounts, kernel modules, or storage
drivers.

Before the generated file exists, the flake exposes:

```text
nixosConfigurations.assemblingos-vm
```

After `scripts/prepare-nixos-host.sh` copies and stages the generated hardware
file, it also exposes:

```text
nixosConfigurations.windows-laptop
```

This keeps the repository evaluable on the Mac while preventing a fake hardware
configuration from being mistaken for an installable laptop system.

## Safety Boundary

The scripts build and inspect configurations. They do not:

- repartition disks
- disable BitLocker
- modify Windows
- run `darwin-rebuild switch`
- run `nixos-rebuild switch`

Applying a system configuration remains an explicit user action.
