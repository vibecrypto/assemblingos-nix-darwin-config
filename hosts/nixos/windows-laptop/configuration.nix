{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Most modern Windows dual-boot laptops use UEFI. If the machine uses a
  # different boot mode, review this before building.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
