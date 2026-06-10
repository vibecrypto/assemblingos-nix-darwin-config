{
  pkgs,
  primaryUser,
  ...
}:
{
  home = {
    username = primaryUser;
    homeDirectory =
      if pkgs.stdenv.isDarwin then
        "/Users/${primaryUser}"
      else
        "/home/${primaryUser}";

    # Keep this value stable after the first Home Manager activation.
    stateVersion = "26.05";
  };

  programs = {
    home-manager.enable = true;

    git.enable = true;
    gh.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
