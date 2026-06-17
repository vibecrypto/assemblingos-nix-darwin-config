{ ... }: {
  homebrew = {
    enable = true;

    brews = [
      "mas"
    ];

    casks = [
      "obs"
      "tradingview"
      "cmux"
      "codex-app"
      "handbrake"
    ];

    masApps = {
      # "Yoink" = 457622435;
    };

    # Keep first activation non-destructive and repeatable. Tighten cleanup only
    # after every existing brew/cask has been reviewed and declared.
    onActivation.cleanup = "none";
    onActivation.autoUpdate = false;
    onActivation.upgrade = false;
  };
}
