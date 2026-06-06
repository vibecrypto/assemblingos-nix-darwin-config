{ ... }: {
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "drg";
    autoMigrate = true;
  };
}
