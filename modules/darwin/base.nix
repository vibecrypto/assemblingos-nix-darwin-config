{ ... }: {
  # Determinate Systems manages the Nix installation and updates.
  nix.enable = false;
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  programs.zsh.enable = true;

  system.primaryUser = "drg";
  system.stateVersion = 6;
}
