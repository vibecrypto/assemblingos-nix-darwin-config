{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Editors
    neovim
    emacs

    # Shell and CLI
    wget
    fzf
    ripgrep
    fd
    jq

    # AI coding agents available on both Darwin and Linux
    codex
    opencode
    claude-code
    pi-coding-agent

    # Developer tooling
    lua-language-server
    ty
    ruff
  ];
}
