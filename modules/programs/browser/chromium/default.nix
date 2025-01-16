{
  home-manager.sharedModules = [
    (_: {
      programs = {
        chromium = {
          enable = true;
        };
      };
    })
  ];
}
