{
  lib,
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

  # One declared name drives every macOS identity: the shell prompt / ssh
  # (HostName), the Sharing + AirDrop name (ComputerName), and the Bonjour
  # ".local" name (LocalHostName, which `assemblingos-update` keys off).
  networking.hostName = hostName;
  networking.computerName = hostName;
  networking.localHostName = hostName;

  programs.zsh.enable = true;

  # Minimal, on-brand prompt for every terminal: just "user@host " — no path,
  # no "> ". Overrides nix-darwin's default `prompt suse` theme. Scoped to this
  # host so other machines in the fleet keep their own prompt.
  programs.zsh.promptInit = lib.mkIf (hostName == "AssemblingOS") ''
    PROMPT='%n@%m '
  '';

  # Primary macOS user supplied by the host definition in flake.nix.
  system.primaryUser = primaryUser;
  users.users.${primaryUser}.home = "/Users/${primaryUser}";
  system.stateVersion = 6;
}
