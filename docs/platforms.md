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

Linux support should be added as separate host outputs later:

```nix
nixosConfigurations."<linux-hostname>" = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./modules/nixos/base.nix
  ];
};
```

Do not add Linux platforms to a Darwin host's `nixpkgs.hostPlatform`.

## Extra Platforms

The Darwin config includes:

```nix
extra-platforms = x86_64-darwin aarch64-darwin
```

That helps Apple Silicon build Darwin packages for both Apple Silicon and Intel Darwin where supported. It does not activate Linux support for this Mac host.
