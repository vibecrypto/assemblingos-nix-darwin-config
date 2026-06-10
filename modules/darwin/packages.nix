{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Darwin terminal and window management
    ghostty-bin
    aerospace

    # Darwin productivity and GUI apps available in nixpkgs
    obsidian
    google-chrome
    keymapp
    raycast
    whatsapp-for-mac
  ];
}
