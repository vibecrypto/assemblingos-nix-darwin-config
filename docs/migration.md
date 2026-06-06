# AssemblingOS Darwin Migration

The source of truth for the current Darwin host is this repository.

## Host

- Host configuration: `DRs-MacBook-Pro`
- Platform: `aarch64-darwin`
- Primary user: `drg`

## New Laptop Checklist

1. Install Nix using the Determinate Systems installer.
2. Clone or copy this repository onto the new machine.
3. Check the host profile in `flake.nix`.
   - Current profile: `DRs-MacBook-Pro`
   - Build command uses the profile after `.#`.
4. Check the primary user in `modules/darwin/base.nix`.
   - Current user: `drg`
   - Change it if the new macOS username is different.
5. Check the platform in `modules/darwin/base.nix`.
   - Apple Silicon Macs use `aarch64-darwin`.
   - Intel Macs use `x86_64-darwin`.
6. Validate the flake.
7. Build the system.
8. Switch only after the build passes and the host/user values are correct.

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
- Ignored editor/build files such as `#flake.nix#`, `.swp`, `.swo`, `flake.nix~`, `test`, and `result` do not travel through Git.
- Linux/NixOS support should be added as separate `nixosConfigurations` later, not inside the active Darwin host.
