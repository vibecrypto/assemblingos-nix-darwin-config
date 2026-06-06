{
  description = "AssemblingOS lab for evaluating Herdr";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    herdr.url = "github:ogulcancelik/herdr/v0.6.8";
  };

  outputs = { nixpkgs, herdr, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = [
              herdr.packages.${system}.default
            ];

            shellHook = ''
              echo "Herdr lab shell"
              echo "Run: herdr --help"
              echo "Leave with: exit"
            '';
          };
        });
    };
}
