# Install AssemblingOS On The NixOS Laptop

This guide starts after NixOS has been installed safely beside Windows.

## Important Boundary

The NixOS installer must generate the real laptop hardware configuration.
AssemblingOS does not create disk UUIDs or hardware settings in advance.

The prepared physical host is:

```text
windows-laptop
```

It currently assumes:

- architecture: `x86_64-linux`
- username: `drg`
- desktop: GNOME
- boot mode: UEFI with systemd-boot
- timezone: `Pacific/Auckland`

Confirm these choices before the final switch.

## 1. Complete The NixOS Installation

Use the current official graphical ISO and installer:

```text
https://nixos.org/download/
```

For the first test, retain the installer-generated configuration and confirm:

- Windows still boots
- NixOS boots
- network works
- keyboard and trackpad work
- graphics work
- sound works
- suspend/resume works

## 2. Clone AssemblingOS

Configure GitHub SSH access, then:

```bash
cd ~
git clone git@github.com:vibecrypto/assemblingos-nix-darwin-config.git nix-darwin-config
cd ~/nix-darwin-config
```

## 3. Import The Real Hardware Configuration

```bash
bash scripts/prepare-nixos-host.sh windows-laptop
```

This copies:

```text
/etc/nixos/hardware-configuration.nix
```

to:

```text
hosts/nixos/windows-laptop/hardware-configuration.nix
```

Review it, then add it to Git:

```bash
git add hosts/nixos/windows-laptop/hardware-configuration.nix
```

Nix flakes only include tracked or staged files, so staging is required before
the flake can see the new hardware file.

## 4. Validate

```bash
nix flake show
nix eval \
  .#nixosConfigurations.windows-laptop.config.system.build.toplevel.drvPath
```

## 5. Build Without Switching

```bash
sudo nixos-rebuild build --flake .#windows-laptop
```

## 6. Apply

Only after the build succeeds:

```bash
sudo nixos-rebuild switch --flake .#windows-laptop
```

Reboot and test both NixOS and Windows again.

## 7. Commit The Host

After successful boot and verification:

```bash
git status --short
git commit -m "host: add windows laptop hardware configuration"
git push
```

The hardware file contains machine-specific filesystem identifiers but should
not contain passwords or private keys.

## 8. Test A Shared Project

```bash
mkdir -p ~/Projects/AssemblingMusic
cd ~/Projects/AssemblingMusic
nix flake init -t path:$HOME/nix-darwin-config#python
nix develop
python --version
uv --version
```
