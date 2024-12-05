{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.bat = {
        enable = true;
      };
      home = {
        file = {
          ".config/bat/theme/Catppuccin Mocha.tmTheme".text = builtins.readFile (pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/bat/refs/heads/main/themes/Catppuccin%20Mocha.tmTheme";
            sha256 = "0jrpfd06hviw82xl74m3favq58a586wa7h1qymakx14l8zla26sh";
          });
          ".config/bat/config".text = ''
            --theme="Catppuccin Mocha"
          '';
        };
        shellAliases = {
          cat = "bat";
        };
      };
    })
  ];
}
