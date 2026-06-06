{
  description = "AssemblingOS Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, ... }: {
    darwinConfigurations."DRs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        ./modules/darwin/base.nix
        ./modules/darwin/packages.nix
        ./modules/darwin/homebrew.nix
        nix-homebrew.darwinModules.nix-homebrew
        ./modules/darwin/nix-homebrew.nix
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
        }
      ];
    };
  };
}
