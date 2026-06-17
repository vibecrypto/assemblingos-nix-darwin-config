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

  # macOS Application Firewall, declared so it survives every rebuild.
  #   enable            - block unsolicited inbound connections.
  #   allowSigned/App   - still let Apple + notarised apps receive connections,
  #                       so normal software keeps working without prompts.
  #   enableStealthMode - don't answer ping / port probes (quieter on the LAN).
  networking.applicationFirewall = {
    enable = true;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };

  programs.zsh.enable = true;

  # On-brand prompt for every terminal, scoped to this host (overrides
  # nix-darwin's default `prompt suse`): the THECAIO brand mark in bold crimson,
  # the host in teal, the current dir dimmed grey, and a green caret —
  # e.g. "THECAIO@AssemblingOS ~/Claude ❯ ".
  programs.zsh.promptInit = lib.mkIf (hostName == "AssemblingOS") ''
    PROMPT='%B%F{160}THECAIO%f%b@%F{37}%m%f %F{244}%~%f %F{green}❯%f '
  '';

  # Primary macOS user supplied by the host definition in flake.nix.
  system.primaryUser = primaryUser;
  users.users.${primaryUser}.home = "/Users/${primaryUser}";
  system.stateVersion = 6;
}
