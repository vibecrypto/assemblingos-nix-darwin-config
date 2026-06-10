{
  hostName,
  pkgs,
  primaryUser,
  ...
}:
{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;

  users.users.${primaryUser} = {
    isNormalUser = true;
    description = "AssemblingOS user";
    extraGroups = [
      "audio"
      "networkmanager"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  services.openssh.enable = false;

  system.stateVersion = "26.05";
}
