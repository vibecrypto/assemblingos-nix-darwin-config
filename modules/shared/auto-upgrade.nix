# Cross-platform option surface for AssemblingOS scheduled auto-upgrade.
#
# Model: fleet / pull. A machine rebuilds from the PUBLISHED flake on a timer.
# New package versions enter the system only when the maintainer bumps and
# pushes flake.lock, so every machine converges on the same tested pin.
#
# The option is declared here once; modules/darwin/auto-upgrade.nix and
# modules/nixos/auto-upgrade.nix provide the platform-specific scheduler.
{ lib, ... }:
{
  options.assemblingos.autoUpgrade = {
    enable = lib.mkEnableOption "scheduled AssemblingOS auto-upgrade (fleet/pull model)";

    flake = lib.mkOption {
      type = lib.types.str;
      default = "github:vibecrypto/assemblingos-nix-darwin-config";
      description = "Flake reference to rebuild from. The host name is appended automatically.";
    };

    dates = lib.mkOption {
      type = lib.types.str;
      default = "weekly";
      description = ''
        Schedule. On NixOS this is a systemd calendar expression
        (e.g. "weekly", "Mon 09:00"). On Darwin the launchd schedule is a fixed
        weekly run (Monday 09:00) for now; this string is currently NixOS-only.
      '';
    };
  };
}
