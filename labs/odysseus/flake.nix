{
  description = "AssemblingOS lab for evaluating Odysseus";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, ... }:
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
              pkgs.python312
              pkgs.uv
              pkgs.git
              pkgs.tmux
              pkgs.sqlite
              pkgs.ffmpeg
            ];

            shellHook = ''
              export APP_BIND="127.0.0.1"
              export APP_PORT="7860"
              export PYTHONNOUSERSITE=1
              export PIP_DISABLE_PIP_VERSION_CHECK=1

              echo "Odysseus lab shell"
              echo "Recommended next step:"
              echo "  git clone https://github.com/pewdiepie-archdaemon/odysseus.git app"
              echo "Then follow labs/odysseus/README.md"
            '';
          };
        });
    };
}
