# New Laptop Bootstrap

Use this checklist to move AssemblingOS to a new MacBook.

The current command-by-command first-version guide is:

```text
docs/install-macos.md
```

## Goal

Bring the new laptop to the same reproducible Darwin system state from Git, without copying local caches, virtual environments, lab data, model downloads, or editor temp files.

Use GitHub as the portable source of truth:

- `assemblingos-nix-darwin-config`: this system repository
- `assemblingos-agent-skills`: reusable agent skills and adapters

## Before Switching

Confirm these values on the new laptop:

- macOS username: currently `drg`
- host profile name: currently `DRs-MacBook-Pro`
- platform: Apple Silicon uses `aarch64-darwin`
- Nix installer: Determinate Systems is expected
- GitHub access: SSH key or HTTPS token configured enough to clone private repos

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
3. Install or open Codex using the current official OpenAI install path for your chosen Codex surface.
4. Clone the AssemblingOS system repository:

```bash
cd ~
git clone <ASSEMBLINGOS_NIX_DARWIN_REPO_URL> nix-darwin-config
```

5. Enter the repo:

```bash
cd ~/nix-darwin-config
```

6. Read the local docs before changing the system:

```bash
sed -n '1,220p' README.md
sed -n '1,260p' docs/migration.md
sed -n '1,260p' docs/package-placement.md
```

7. Validate the flake:

```bash
nix flake show --no-write-lock-file
```

8. Build without changing the active system:

```bash
darwin-rebuild build --flake .#DRs-MacBook-Pro
```

9. Switch only after the build passes and the username/profile values are correct:

```bash
darwin-rebuild switch --flake .#DRs-MacBook-Pro
```

## Install AssemblingOS Skills

Clone the skills repository:

```bash
cd ~
git clone <ASSEMBLINGOS_AGENT_SKILLS_REPO_URL> assemblingos-agent-skills
```

Install the Codex adapter:

```bash
cd ~/assemblingos-agent-skills
nix run .#install-agent-skills -- codex
```

Restart Codex after installing or updating skills.

Test the skill:

```text
Use the assemblingos-tool-evaluator skill. Evaluate this tool for AssemblingOS: https://www.raycast.com/
```

## Start A New Codex Instance

Use the prompt in:

```text
docs/agent-handoff-prompts.md
```

Codex memory from the old laptop is helpful if present, but it is not the source of truth. The new instance should read this repository and the skills repository first.

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
- agent handoff prompts
- skill source repo

Do not migrate through Git:

- `.venv`
- `venv`
- `.env`
- lab app clones
- ChromaDB data
- model caches
- Nix store paths
- editor temp files
- Codex temporary attachments
- old manual app clones

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

Check Codex skill installation:

```bash
test -f ~/.codex/skills/assemblingos-tool-evaluator/SKILL.md
```

## Next Layer

After the Darwin system works on the new laptop, add Home Manager as a separate phase for user-level configuration:

- shell aliases/functions
- Git identity
- editor preferences
- agent config files
- dotfiles

Do not mix Home Manager migration with the first system migration unless there is a specific blocker.
