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

    # Developer tooling
    lua-language-server
    ty
    ruff
  ];
}
