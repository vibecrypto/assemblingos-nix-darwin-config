{
  description = "AssemblingOS Python and uv project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
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
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              python312
              uv
            ];

            env = {
              PYTHONNOUSERSITE = "1";
              UV_PROJECT_ENVIRONMENT = ".venv";
            };

            shellHook = ''
              echo "AssemblingOS Python environment"
              python --version
              uv --version
            '';
          };
        }
      );
    };
}
