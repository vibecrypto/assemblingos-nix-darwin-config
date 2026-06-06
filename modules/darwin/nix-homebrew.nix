{ ... }: {
  nix-homebrew = {
    enable = true;

    # Keep Intel Homebrew available on Apple Silicon for casks/brews that still need Rosetta.
    enableRosetta = true;

    # This must match the macOS user that owns the Homebrew prefixes.
    user = "drg";

    # Adopt an existing Homebrew installation into nix-homebrew management.
    autoMigrate = true;
  };
}
