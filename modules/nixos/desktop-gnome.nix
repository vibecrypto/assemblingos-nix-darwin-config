{ ... }:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    printing.enable = true;
  };

  hardware.bluetooth.enable = true;
}
