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

    # User-facing tooling lives here (not environment.systemPackages) so it
    # travels with the person and stays portable across Darwin/Linux. The system
    # keeps only a tiny recovery baseline; see modules/shared/packages.nix.
    packages = with pkgs; [
      # AI coding agents
      codex
      opencode
      claude-code
      pi-coding-agent

      # Editor / shell tools
      emacs
      wget
      fzf

      # Developer tooling
      lua-language-server
      ty
      ruff
    ];
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      # Privacy noreply address keeps the real email out of every commit while
      # still attributing commits to the GitHub account.
      settings.user = {
        name = "Vibe";
        email = "291395314+vibecrypto@users.noreply.github.com";
      };
    };
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
