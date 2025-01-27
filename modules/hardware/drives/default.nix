{ ... }: {
  imports = [
    #./games.nix
    #./seagate.nix
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  services.blueman.enable = true;
}
