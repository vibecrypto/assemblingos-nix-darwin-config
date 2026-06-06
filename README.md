# AssemblingOS

AssemblingOS is a Nix-centered work environment for macOS/Darwin first, with Linux/NixOS support planned as a first-class path.

The goal is to make a new machine reproducible from Git while keeping experimental tools isolated in labs.

## Start Here

For a new MacBook setup, start with:

```text
docs/new-laptop-bootstrap.md
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

## Repository Roles

This repository is the production Darwin system source of truth:

- shared system packages
- Darwin modules
- Homebrew declarations managed through nix-darwin/nix-homebrew
- documentation
- project-local labs

Agent skills live in a separate repository:

```text
assemblingos-agent-skills
```

Keep skills separate because they should be reusable by Codex, Claude, OpenCode, and future agents without coupling them to one host configuration.

## Safety Rules

- Build before switch.
- Do not run `darwin-rebuild switch` until the build passes.
- Keep experimental tools in `labs/` first.
- Do not commit `.env`, `.venv`, app clones, model caches, or local data.
- Commit every verified logical change.

## Current Darwin Host

Current host profile:

```text
DRs-MacBook-Pro
```

Validate:

```bash
nix flake show --no-write-lock-file
darwin-rebuild build --flake .#DRs-MacBook-Pro
```

Apply only when ready:

```bash
darwin-rebuild switch --flake .#DRs-MacBook-Pro
```
