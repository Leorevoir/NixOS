# { pkgs, ... }:
# {
#   home-manager.sharedModules = [
#     (_: {
#       programs.bat = {
#         enable = true;
#       };
#       home = {
#         file = {
#           ".config/bat/theme/Catppuccin Mocha.tmTheme".text = builtins.readFile (pkgs.fetchurl {
#             url = "https://raw.githubusercontent.com/catppuccin/bat/refs/heads/main/themes/Catppuccin%20Macchiato.tmTheme";
#             sha256 = "zL18U4AXMO8+gBH3T/HDl8e7OYjIRqUdeeb0i4V7kVI=";
#           });
#           ".config/bat/config".text = ''
#             --theme="Catppuccin Mocha"
#           '';
#         };
#         shellAliases = {
#           cat = "bat";
#         };
#       };
#     })
#   ];
# }
{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.bat = {
        enable = true;
        config = {
          theme = "Catppuccin Frappe";
        };
        themes = {
          "Catppuccin Frappe" = {
            src = pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/catppuccin/bat/refs/heads/main/themes/Catppuccin%20Frappe.tmTheme";
              sha256 = "kJZZDy3xk8oPe0zM//B4bAA6sYufyAKuEPiKq04Lkvk=";
            };
          };
        };
      };

      home.shellAliases = {
        cat = "bat";
      };
    })
  ];
}
