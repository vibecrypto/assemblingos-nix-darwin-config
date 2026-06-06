{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Editors
    neovim
    emacs

    # Shell and CLI
    wget
    fzf

    # Terminal and window management
    ghostty-bin
    aerospace

    # AI agents
    codex
    opencode
    claude-code
    pi-coding-agent

    # Developer tooling
    lua-language-server
    ty
    ruff

    # Productivity and GUI apps available in nixpkgs
    obsidian
    google-chrome
    keymapp
    raycast
    whatsapp-for-mac
  ];
}
