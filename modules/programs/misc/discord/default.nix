{
  home-manager.sharedModules = [
    (_: {
      home.file.".config/discord/settings.json".text = ''
        {
          "SKIP_HOST_UPDATE": true,
          "openasar": {
            "setup": true,
            "cmdPreset": "balanced",
            "noTyping": true,
            "quickstart": true,
            "css": "@import url(\"https://catppuccin.github.io/discord/dist/catppuccin-macchiato-teal.theme.css\");"
          },
          "IS_MAXIMIZED": false,
          "IS_MINIMIZED": false,
          "trayBalloonShown": true,
          "chromiumSwitches": {}
        }
      '';
    })
  ];
}
