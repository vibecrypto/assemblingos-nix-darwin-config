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
    ];

    masApps = {
      # "Yoink" = 457622435;
    };

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
