# AssemblingOS Tool Taxonomy

This file tracks how tools are grouped in the Darwin system flake.

## Current Production Categories

- Editors: `neovim`, `emacs`
- Shell and CLI: `wget`, `fzf`
- Archive utilities: not installed yet; candidates include `unzip`, `the-unarchiver`/`unar`, `p7zip`, and `bsdtar`
- Terminal and window management: `ghostty-bin`, `aerospace`
- AI agents: `codex`, `opencode`, `claude-code`, `pi-coding-agent`
- Developer tooling: `lua-language-server`, `ty`, `ruff`
- Productivity and GUI apps from nixpkgs: `obsidian`, `google-chrome`, `keymapp`, `raycast`, `whatsapp-for-mac`
- Homebrew brews: `mas`
- Homebrew casks: `obs`, `tradingview`, `cmux`, `codex-app`

## Promotion Rule

Stable daily tools can live in the production flake. Experimental tools should start in project-local lab flakes before being promoted.

## Placement Rules

- Nix system packages are for stable daily CLI, developer, and reproducible GUI tools that work well from nixpkgs.
- Homebrew casks are for macOS GUI apps, proprietary apps, drivers, or apps with better Darwin support through Homebrew.
- Project-local lab flakes are for experimental AI/dev tools, fast-moving stacks, and tools that may not become part of the daily system.
- Future Home Manager modules should own user behavior: shell config, editor config, Git config, aliases, and per-user package preferences.
- Future NixOS support should live in Linux-specific host modules. Do not mix Linux host settings into the Darwin modules.

## Agent-First Tool Preference

When multiple tools solve the same task, prefer the one that is easiest for an agent to use safely:

- CLI or local API over GUI-only workflows
- non-interactive commands over prompts
- predictable output over decorative output
- stable package in nixpkgs over manual install
- cross-platform support over platform-only support when quality is comparable
