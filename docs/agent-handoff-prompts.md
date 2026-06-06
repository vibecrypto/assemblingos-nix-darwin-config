# Agent Handoff Prompts

Use these prompts when starting a fresh Codex, Claude, OpenCode, or other agent session on a new machine.

## New Laptop First Prompt

```text
You are helping me continue AssemblingOS on a new MacBook Pro M1 64GB 2TB.

Main rules:
- Nix/nix-darwin is the source of truth for production system tools.
- Experimental tools go into labs with project-local flakes/devShells.
- Prefer cross-platform Darwin/Linux tools when quality is comparable.
- Prefer agent-first tools: CLI/API, scriptable behavior, stable output, clear errors, good docs, and local-first operation where possible.
- Do not install, modify files, rebuild, switch, or commit until I confirm.
- Use Git for every approved change and commit each verified logical change.
- Build before switch.
- Never run darwin-rebuild switch without explicit approval.

Start by reading:
- /Users/drg/nix-darwin-config/README.md
- /Users/drg/nix-darwin-config/docs/new-laptop-bootstrap.md
- /Users/drg/nix-darwin-config/docs/tool-taxonomy.md
- /Users/drg/nix-darwin-config/docs/package-placement.md
- /Users/drg/nix-darwin-config/docs/tool-selection-workflow.md
- /Users/drg/nix-darwin-config/docs/migration.md
- /Users/drg/nix-darwin-config/docs/platforms.md

Then check:
- git status in /Users/drg/nix-darwin-config
- whether ~/.codex/skills/assemblingos-tool-evaluator/SKILL.md exists
- whether ~/assemblingos-agent-skills exists

Summarize the current state briefly and ask me what to do next.
```

## Tool Evaluation Prompt

```text
Use the assemblingos-tool-evaluator workflow.

Evaluate this tool for AssemblingOS: <TOOL_NAME_OR_URL>

Before recommending installation:
1. Check whether it is already installed or declared in AssemblingOS.
2. Check nixpkgs, Home Manager, nix-darwin/NixOS modules, Homebrew, official upstream flakes, Docker, and manual install paths.
3. Prefer cross-platform Darwin/Linux tools when quality is comparable.
4. Prefer agent-first tools with CLI/API, stable output, and clear non-interactive behavior.
5. Recommend production, Darwin-specific, NixOS-specific, Home Manager, Homebrew, lab flake/devShell, upstream flake, manual install, reject, or watchlist.
6. Ask for confirmation before changing anything.
```

## Lab Continuation Prompt

```text
Continue the AssemblingOS lab work.

Before doing anything:
1. Check git status in /Users/drg/nix-darwin-config.
2. Read the lab README for the specific lab I name.
3. Summarize what is already configured.
4. Do not install dependencies, modify files, rebuild, switch, or commit until I confirm.

Lab to continue: <LAB_NAME>
```

## Clean Migration Reminder

```text
Treat GitHub repositories as the portable source of truth.

Do not rely on old Codex memory, local caches, .venv folders, app clones, model downloads, or temporary files. Read the repository docs first and reconstruct environments from Nix flakes/devShells where possible.
```
