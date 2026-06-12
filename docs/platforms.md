# AssemblingOS Platforms

Each host configuration has exactly one active `hostPlatform`.

## Darwin Platforms

- Apple Silicon Mac: `aarch64-darwin`
- Intel Mac: `x86_64-darwin`

The current host uses:

```nix
nixpkgs.hostPlatform = "aarch64-darwin";
```

## Linux/NixOS Platforms

- x86_64 Linux/NixOS: `x86_64-linux`
- ARM Linux/NixOS: `aarch64-linux`

Linux support is implemented as separate host outputs:

```nix
nixosConfigurations.assemblingos-vm
nixosConfigurations.windows-laptop
```

`windows-laptop` appears only after its real installer-generated
`hardware-configuration.nix` exists.

Do not add Linux platforms to a Darwin host's `nixpkgs.hostPlatform`.

## Extra Platforms

The Darwin config includes:

```nix
extra-platforms = x86_64-darwin aarch64-darwin
```

That helps Apple Silicon build Darwin packages for both Apple Silicon and Intel Darwin where supported. It does not activate Linux support for this Mac host.
