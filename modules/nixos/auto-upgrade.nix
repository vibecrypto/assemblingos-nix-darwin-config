# NixOS implementation of assemblingos.autoUpgrade.
#
# NixOS ships a native scheduler, so we just wire our option into it. Fleet/pull
# model: rebuild from the published flake's committed lock; no local flake update.
{
  config,
  lib,
  hostName,
  ...
}:
let
  cfg = config.assemblingos.autoUpgrade;
in
{
  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      flake = "${cfg.flake}#${hostName}";
      dates = cfg.dates;
      randomizedDelaySec = "45min";
    };
  };
}
