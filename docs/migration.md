# AssemblingOS Darwin Migration

The source of truth for the current Darwin host is this repository.

For the shortest new-laptop path, start with:

```text
README.md
docs/new-laptop-bootstrap.md
docs/agent-handoff-prompts.md
```

## Host

- Existing-Mac configuration: `DRs-MacBook-Pro`
- Prepared second-Mac configuration: `AssemblingOS`
- Platform: `aarch64-darwin`
- Primary user: `drg`

## New Laptop Checklist

1. Install Nix using the Determinate Systems installer.
2. Clone or copy this repository onto the new machine.
3. Check the host profile in `flake.nix`.
   - New Mac profile: `AssemblingOS`
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

For a more practical command-by-command checklist, see:

```text
docs/new-laptop-bootstrap.md
```

## Validate

```bash
nix flake show --no-write-lock-file
bash scripts/bootstrap-darwin.sh AssemblingOS
```

## Apply

Run this only after a build passes and you are ready to change the active system:

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch \
  --flake .#AssemblingOS
```

## Notes

- `nix.enable = false` is intentional because Determinate Systems manages Nix.
- Home Manager is enabled for the shared user baseline.
- Homebrew is managed through `nix-homebrew`.
- Homebrew cleanup/update/upgrade are disabled during activation to keep the
  migration non-destructive and repeatable.
- Ignored editor/build files such as `#flake.nix#`, `.swp`, `.swo`, `flake.nix~`, `test`, and `result` do not travel through Git.
- Linux/NixOS support exists as separate `nixosConfigurations`; it is not added
  to a Darwin host.
- Codex memory is not the source of truth. A new agent should read this repo and the `assemblingos-agent-skills` repo first.
- The obsolete `~/.config/nix-darwin` checkout must not be migrated.
