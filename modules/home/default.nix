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

    # AI coding agents — used by the person, so they live in the per-user
    # Home Manager profile rather than system-wide. Cross-platform (Darwin + Linux).
    packages = with pkgs; [
      codex
      opencode
      claude-code
      pi-coding-agent
    ];
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      # Privacy noreply address keeps the real email out of every commit while
      # still attributing commits to the GitHub account.
      userName = "Vibe";
      userEmail = "291395314+vibecrypto@users.noreply.github.com";
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
