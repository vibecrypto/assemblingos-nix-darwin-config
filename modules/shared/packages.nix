{ pkgs, ... }:
{
  # Minimal system baseline: tools wanted in root / recovery shells, where the
  # per-user Home Manager profile isn't on PATH. Everything user-facing lives in
  # Home Manager (modules/home/default.nix) for portability and a clean
  # machine-vs-person split.
  environment.systemPackages = with pkgs; [
    neovim # editor for root/recovery
    git # version control, incl. fixing the flake as root
    ripgrep
    fd
    jq
  ];
}
