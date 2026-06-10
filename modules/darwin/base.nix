{
  hostName,
  primaryUser,
  system,
  ...
}:
{
  # Determinate Systems manages the Nix installation and updates.
  nix.enable = false;

  # Extra Darwin platforms this Apple Silicon Mac can build for.
  # Linux/NixOS hosts should be separate nixosConfigurations, not added here.
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  # Active platform for this Darwin host.
  nixpkgs.hostPlatform = system;

  networking.hostName = hostName;

  programs.zsh.enable = true;

  # Primary macOS user supplied by the host definition in flake.nix.
  system.primaryUser = primaryUser;
  users.users.${primaryUser}.home = "/Users/${primaryUser}";
  system.stateVersion = 6;
}
