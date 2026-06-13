# Darwin implementation of assemblingos.autoUpgrade.
#
# nix-darwin has no system.autoUpgrade (that is a NixOS module), so we schedule a
# launchd daemon that rebuilds from the published flake. Off unless
# `assemblingos.autoUpgrade.enable = true` on the host.
{
  config,
  lib,
  pkgs,
  hostName,
  ...
}:
let
  cfg = config.assemblingos.autoUpgrade;

  updateScript = pkgs.writeShellApplication {
    name = "assemblingos-autoupgrade";
    runtimeInputs = [ pkgs.git ];
    text = ''
      set -euo pipefail
      # Determinate Nix + the active system provide nix and darwin-rebuild.
      export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH"

      flake_ref="${cfg.flake}#${hostName}"
      echo "AssemblingOS auto-upgrade: rebuilding from ''${flake_ref}"
      # switch builds first and only activates on success, matching the
      # build-before-switch safety rule.
      darwin-rebuild switch --flake "''${flake_ref}"
    '';
  };
in
{
  config = lib.mkIf cfg.enable {
    launchd.daemons.assemblingos-autoupgrade = {
      serviceConfig = {
        ProgramArguments = [ "${updateScript}/bin/assemblingos-autoupgrade" ];
        StartCalendarInterval = [
          {
            Weekday = 1;
            Hour = 9;
            Minute = 0;
          }
        ];
        RunAtLoad = false;
        StandardOutPath = "/var/log/assemblingos-autoupgrade.log";
        StandardErrorPath = "/var/log/assemblingos-autoupgrade.log";
      };
    };
  };
}
