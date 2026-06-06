{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      # Ensure determinate systems manages installation and updates
      nix.enable = false;
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
          pkgs.emacs
	  pkgs.wget
	  pkgs.obsidian
	  pkgs.ghostty-bin
	  pkgs.opencode
	  pkgs.pi-coding-agent
	  pkgs.aerospace
	  pkgs.codex
	  pkgs.google-chrome
	  pkgs.keymapp
	  pkgs.raycast
	  pkgs.claude-code
	  pkgs.fzf
	  pkgs.lua-language-server
	  pkgs.ty
	  pkgs.ruff
	  pkgs.claude-code
	  pkgs.whatsapp-for-mac
        ];

      system.primaryUser = "drg";
      homebrew = {
        enable = true;
	brews = [
          "mas"
        ];
	casks = [
	  "obs"
	  "tradingview"
	  "cmux"
	  "codex-app"
        ];
	masApps = {
         # "Yoink" = 457622435;
        };
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };  

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
        programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."DRs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
      configuration
      nix-homebrew.darwinModules.nix-homebrew
       {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;
           # services.nix-daemon.enable = true;
           # nix.settings.experimental-features = "nix-command flakes";
            # User owning the Homebrew prefix
            user = "drg";
	    autoMigrate = true;
	   };
        }

         
      ];
    };
  };
}
