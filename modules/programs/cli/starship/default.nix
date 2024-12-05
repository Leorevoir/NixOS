{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.starship = {
        enable = true;
      };

      home.file.".config/starship/starship.toml".text =
        let
          originalConfig = builtins.readFile (pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/starship/main/starship.toml";
            sha256 = "0sx7fqpf231qjrcsh8nnnjc8irc9q6sbbavs6mxds2i4fjxxqdsn";
          });
        in
        pkgs.lib.replaceStrings
          [
            "palette = \"catppuccin_macchiato\""
            "󰄛"
          ]
          [
            "palette = \"catppuccin_mocha\""
            ""
          ]
          originalConfig;
    })
  ];
}
