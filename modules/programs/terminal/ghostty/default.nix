{
  home-manager.sharedModules = [
    (_: {
      programs.ghostty = {
        enable = true;
      };
      home.file.".config/ghostty/config".text = ''
        font-family = JetBrainsMono Nerd Font
        font-size = 12

        theme = catppuccin-frappe

        cursor-style = block

        window-padding-x = 5
        # window-padding-x = 21
        # window-padding-y = 21
        window-decoration = false
      '';
    })
  ];
}
