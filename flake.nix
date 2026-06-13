{
  description = "AssemblingOS reproducible Darwin and NixOS systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    # Track unstable to match nixpkgs (release branches lag nixpkgs-unstable and
    # eventually fail to evaluate against it).
    home-manager.url = "github:nix-community/home-manager/master";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      ...
    }:
    let
      mkHomeManager =
        { primaryUser }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "assemblingos-backup";
          home-manager.extraSpecialArgs = { inherit primaryUser; };
          home-manager.users.${primaryUser} = import ./modules/home;
        };

      mkDarwinHost =
        {
          hostName,
          primaryUser,
          system ? "aarch64-darwin",
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit
              hostName
              inputs
              primaryUser
              system
              ;
          };

          modules = [
            ./modules/darwin/base.nix
            ./modules/shared/packages.nix
            ./modules/shared/auto-upgrade.nix
            ./modules/darwin/auto-upgrade.nix
            ./modules/darwin/packages.nix
            ./modules/darwin/homebrew.nix
            nix-homebrew.darwinModules.nix-homebrew
            ./modules/darwin/nix-homebrew.nix
            home-manager.darwinModules.home-manager
            (mkHomeManager { inherit primaryUser; })
            {
              system.configurationRevision = self.rev or self.dirtyRev or null;
            }
          ];
        };

      mkNixosHost =
        {
          hostName,
          primaryUser,
          system ? "x86_64-linux",
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit
              hostName
              inputs
              primaryUser
              system
              ;
          };

          modules = [
            ./modules/nixos/base.nix
            ./modules/nixos/desktop-gnome.nix
            ./modules/shared/packages.nix
            ./modules/shared/auto-upgrade.nix
            ./modules/nixos/auto-upgrade.nix
            home-manager.nixosModules.home-manager
            (mkHomeManager { inherit primaryUser; })
          ] ++ extraModules;
        };

      windowsLaptopHardware =
        ./hosts/nixos/windows-laptop + "/hardware-configuration.nix";
    in
    {
      # Existing Mac. Build with:
      # darwin-rebuild build --flake .#DRs-MacBook-Pro
      darwinConfigurations."DRs-MacBook-Pro" = mkDarwinHost {
        hostName = "DRs-MacBook-Pro";
        primaryUser = "drg";
      };

      # Reproducible second-Mac profile. Claimed by the M1 Max MacBook Pro whose
      # macOS user is "thecaio" (hostname will be set to AssemblingOS-MacBook-Pro
      # on switch).
      darwinConfigurations."AssemblingOS-MacBook-Pro" = mkDarwinHost {
        hostName = "AssemblingOS-MacBook-Pro";
        primaryUser = "thecaio";
      };

      # The physical host appears after scripts/prepare-nixos-host.sh copies the
      # installer-generated hardware configuration into the repository.
      nixosConfigurations =
        {
          "assemblingos-vm" = mkNixosHost {
            hostName = "assemblingos-vm";
            primaryUser = "drg";
            extraModules = [
              "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
              {
                virtualisation = {
                  memorySize = 4096;
                  cores = 4;
                };
              }
            ];
          };
        }
        // nixpkgs.lib.optionalAttrs (builtins.pathExists windowsLaptopHardware) {
          "windows-laptop" = mkNixosHost {
            hostName = "windows-laptop";
            primaryUser = "drg";
            extraModules = [
              ./hosts/nixos/windows-laptop/configuration.nix
            ];
          };
        };

      templates = {
        node = {
          path = ./templates/node;
          description = "Cross-platform Node.js project devShell";
        };

        python = {
          path = ./templates/python;
          description = "Cross-platform Python and uv project devShell";
        };
      };
    };
}
