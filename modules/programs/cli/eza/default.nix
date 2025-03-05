{ pkgs
, ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.eza = {
        enable = true;
      };
      home = {
        file = {
          ".config/eza/theme.yml".source = ./mocha.yml;
        };
        shellAliases = with pkgs; {
          l = "${eza}/bin/eza -lh  --icons=always";
          ls = "${eza}/bin/eza   --icons=always";
          ll = "${eza}/bin/eza -lha --icons=always --sort=name --group-directories-first";
          tree = "${eza}/bin/eza --icons=always --tree";
        };
      };
    })
  ];
}
