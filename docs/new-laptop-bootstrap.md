# New Laptop Bootstrap

Use this checklist to move AssemblingOS to a new MacBook.

## Goal

Bring the new laptop to the same reproducible Darwin system state from Git, without copying local caches, virtual environments, lab data, or editor temp files.

## Before Switching

Confirm these values on the new laptop:

- macOS username: currently `drg`
- host profile name: currently `DRs-MacBook-Pro`
- platform: Apple Silicon uses `aarch64-darwin`
- Nix installer: Determinate Systems is expected

If the new laptop uses a different macOS username, update:

```nix
system.primaryUser = "drg";
```

If the host profile name should change, update the output name in `flake.nix` and use the same name in rebuild commands:

```bash
darwin-rebuild build --flake .#DRs-MacBook-Pro
```

## Bootstrap Steps

1. Install Nix with the Determinate Systems installer.
2. Restart the terminal so the Nix environment is loaded.
3. Clone the AssemblingOS repository.
4. Enter the repo:

```bash
cd ~/nix-darwin-config
```

5. Validate the flake:

```bash
nix flake show --no-write-lock-file
```

6. Build without changing the active system:

```bash
darwin-rebuild build --flake .#DRs-MacBook-Pro
```

7. Switch only after the build passes and the username/profile values are correct:

```bash
darwin-rebuild switch --flake .#DRs-MacBook-Pro
```

## What To Migrate Through Git

Migrate:

- `flake.nix`
- `flake.lock`
- `modules/`
- `docs/`
- `labs/*/flake.nix`
- `labs/*/flake.lock`
- `labs/*/README.md`
- lab scripts

Do not migrate through Git:

- `.venv`
- `venv`
- `.env`
- lab app clones
- ChromaDB data
- model caches
- Nix store paths
- editor temp files

## After First Switch

Check installed apps and tools:

```bash
which codex
which opencode
which darwin-rebuild
```

Check GUI apps from Nix/Homebrew manually:

- Raycast
- Ghostty
- OBS
- Chrome
- Obsidian

## Next Layer

After the Darwin system works on the new laptop, add Home Manager as a separate phase for user-level configuration:

- shell aliases/functions
- Git identity
- editor preferences
- agent config files
- dotfiles

Do not mix Home Manager migration with the first system migration unless there is a specific blocker.
