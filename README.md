# AssemblingOS

AssemblingOS is a Nix-centered reproducible work environment for macOS/Darwin
and NixOS.

The goal is to make a new machine reproducible from Git while keeping experimental tools isolated in labs.

## Start Here

Every new agent or session should read:

```text
PROJECT_MEMORY.md
```

For the first reproducible version, start with:

```text
docs/first-version-architecture.md
docs/install-macos.md
docs/windows-dual-boot-preflight.md
docs/install-nixos.md
```

For a prompt to give Codex or another coding agent on the new laptop, use:

```text
docs/agent-handoff-prompts.md
```

For deciding where a tool belongs, read:

```text
docs/package-placement.md
docs/tool-selection-workflow.md
docs/tool-taxonomy.md
```

For the reproducible macOS creator setup, read:

```text
docs/creator-workstation.md
```

Before retiring or moving away from the current Mac, read:

```text
docs/pre-move-checklist.md
```

## Repository Roles

This repository is the system source of truth:

- shared system packages
- Darwin modules
- NixOS modules and host bootstrap
- shared Home Manager configuration
- Homebrew declarations managed through nix-darwin/nix-homebrew
- documentation
- project-local labs
- cross-platform project templates

Agent skills live in a separate repository:

```text
assemblingos-agent-skills
```

Keep skills separate because they should be reusable by Codex, Claude, OpenCode, and future agents without coupling them to one host configuration.

## Safety Rules

- Build before switch.
- Do not run `darwin-rebuild switch` or `nixos-rebuild switch` until the build
  passes.
- Keep experimental tools in `labs/` first.
- Do not commit `.env`, `.venv`, app clones, model caches, or local data.
- Commit every verified logical change.

## Current Darwin Host

Active host profile (M1 Max, macOS user `thecaio`):

```text
AssemblingOS
```

Validate:

```bash
nix flake show --no-write-lock-file
darwin-rebuild build --flake .#AssemblingOS
```

Apply only when ready:

```bash
darwin-rebuild switch --flake .#AssemblingOS
```

Day to day, prefer the update command (build-before-switch, then releases the
new lock):

```bash
assemblingos-update
```

See `docs/updating.md` for the full update model. `DRs-MacBook-Pro` remains the
original host profile.

## Prepared Hosts

```text
Darwin:
  DRs-MacBook-Pro
  AssemblingOS

NixOS:
  assemblingos-vm
  windows-laptop (appears after importing real hardware configuration)
```

Inspect everything without applying:

```bash
bash scripts/doctor.sh
```
