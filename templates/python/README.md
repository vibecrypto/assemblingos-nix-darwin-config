# Python Project Template

Create a new project:

```bash
mkdir AssemblingMusic
cd AssemblingMusic
nix flake init -t path:$HOME/nix-darwin-config#python
nix develop
uv init
```

Nix provides Python and `uv`. `uv` manages project-specific dependencies in
`.venv`. Commit `flake.nix`, `flake.lock`, `pyproject.toml`, and `uv.lock`.
