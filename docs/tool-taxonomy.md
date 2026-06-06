# AssemblingOS Tool Taxonomy

This file tracks how tools are grouped in the Darwin system flake.

## Current Production Categories

- Editors: `neovim`, `emacs`
- Shell and CLI: `wget`, `fzf`
- Terminal and window management: `ghostty-bin`, `aerospace`
- AI agents: `codex`, `opencode`, `claude-code`, `pi-coding-agent`
- Developer tooling: `lua-language-server`, `ty`, `ruff`
- Productivity and GUI apps from nixpkgs: `obsidian`, `google-chrome`, `keymapp`, `raycast`, `whatsapp-for-mac`
- Homebrew brews: `mas`
- Homebrew casks: `obs`, `tradingview`, `cmux`, `codex-app`

## Promotion Rule

Stable daily tools can live in the production flake. Experimental tools should start in project-local lab flakes before being promoted.
