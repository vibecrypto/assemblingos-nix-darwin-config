{ ... }: {
  # Determinate Systems manages the Nix installation and updates.
  nix.enable = false;

  # Extra Darwin platforms this Apple Silicon Mac can build for.
  # Linux/NixOS hosts should be separate nixosConfigurations, not added here.
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  # Active platform for this MacBook Pro M1.
  # Examples for other hosts are documented in docs/platforms.md.
  nixpkgs.hostPlatform = "aarch64-darwin";

  programs.zsh.enable = true;

  # Primary macOS user for nix-darwin options that need an owning user.
  # Change this when moving the config to a machine with a different username.
  system.primaryUser = "drg";
  system.stateVersion = 6;
}
