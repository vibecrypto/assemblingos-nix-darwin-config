# AssemblingOS Darwin Migration

The source of truth for the current Darwin host is this repository.

## Host

- Host configuration: `DRs-MacBook-Pro`
- Platform: `aarch64-darwin`
- Primary user: `drg`

## Validate

```bash
nix flake show --no-write-lock-file
darwin-rebuild build --flake .#DRs-MacBook-Pro
```

## Apply

Run this only after a build passes and you are ready to change the active system:

```bash
darwin-rebuild switch --flake .#DRs-MacBook-Pro
```

## Notes

- `nix.enable = false` is intentional because Determinate Systems manages Nix.
- Home Manager is not enabled yet. It is the recommended next layer for user shell, editor, and Git configuration.
- Homebrew is managed through `nix-homebrew`.
