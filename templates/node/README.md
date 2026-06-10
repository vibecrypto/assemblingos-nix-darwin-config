# Node Project Template

Create a new project:

```bash
mkdir AssemblingCRM
cd AssemblingCRM
nix flake init -t path:$HOME/nix-darwin-config#node
nix develop
```

Commit both `flake.nix` and the generated `flake.lock`.
