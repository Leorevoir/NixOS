{ inputs
, pkgs
, pkgs-stable
, username
, terminal
, ...
}:
let
  sddm-themes = pkgs.callPackage ../modules/themes/sddm/themes.nix { };
  scripts = pkgs.callPackage ../modules/scripts { };
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ../modules/programs/games
    ../modules/hardware/drives
    ../modules/programs/terminal/${terminal}
    ../modules/programs/terminal/ghostty
    ../modules/programs/shell/zsh
    ../modules/programs/browser/firefox
    ../modules/programs/browser/chromium
    #TODO: enlever l'alias et remettre le nixvim tel quil etait avant la 24.11
    # ../modules/programs/editor/nixvim
    ../modules/programs/cli/starship
    ../modules/programs/cli/tmux
    ../modules/programs/cli/direnv
    ../modules/programs/cli/fastfetch
    ../modules/programs/cli/lf
    ../modules/programs/cli/lazygit
    ../modules/programs/cli/cava
    ../modules/programs/cli/btop
    ../modules/programs/cli/bat
    ../modules/programs/cli/eza
    # ../modules/programs/cli/pokemon
    ../modules/programs/misc/mpv
    ../modules/programs/misc/spicetify
    ../modules/programs/misc/obs
    ../modules/programs/misc/swww
  ];

  # Common home-manager options that are shared between all systems.
  home-manager.users.${username} =
    { pkgs, ... }:
    {
      xdg.enable = true;
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "24.11";
        packages = with pkgs; [
          # Applications
          #kate
          xfce.thunar

          # Terminal
          bat
          eza
          fzf
          fd
          git
          gh
          bc
          htop
          nix-prefetch-scripts
          ripgrep
          procps
          tldr
          unzip

          # foo-fetch
          starfetch
          fastfetch
          nitch # cute lil neofetch
          microfetch # this is the best one fr
          ipfetch

          # fun
          pokemonsay
          cmatrix
          kittysay
          cowsay
          uwuify
          thefuck
          bonsai
          asciiquarium
          genact

          # useful
          evtest
          libinput
          gmp
          zathura
          usbutils
          webcamoid
          wev
          pkg-config

          # languages
          python3
          gcc
          gpp
          gnumake
          lua
          rustc
          cargo
          nodejs_23
          crystal
          crystalline
          shards
          docker

          # safe editor just in case
          vim

          # tiles map editor for 2D games
          tiled

          # lsp
          nil
          (pkgs.writeShellScriptBin "hello" ''
            echo "Hello ${username}!"
          '')
        ];
      };
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };

  # Filesystems support
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
    "ext4"
    "fat32"
    "btrfs"
  ];

  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };

  # Bootloader.
  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_zen; # _zen_latest, _xanmod_latest _hardened, _rt, _OTHER_CHANNEL, etc.
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = null; # Display bootloader indefinitely until user selects OS
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "1920x1080";
        gfxmodeBios = "1920x1080";
        theme = pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        };
      };
    };
  };

  security = {
    polkit.enable = true;
    #sudo.wheelNeedsPassword = false;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  programs = {
    # Enable dconf for home-manager
    dconf.enable = true;
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Enable sddm login manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "astronaut";
    settings.Theme.CursorTheme = "Bibata-Modern-Classic";
  };

  # Setup auth agent and keyring
  services.gnome.gnome-keyring.enable = true;
  systemd = {
    user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = false;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Default shell
  users.defaultUserShell = pkgs.zsh;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    # new 24.11 /\
    # old 24.05 \/
    # (nerdfonts.override {
    #   fonts = [
    #     "JetBrainsMono"
    #     "FiraCode"
    #   ];
    # })
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.nur.overlays.default
      pkgs-stable
      #TODO: finir le package
      # (self: super: {
      #   betterdiscord = super.callPackage ./../modules/programs/misc/betterdiscord { };
      # })
    ];
  };

  environment.sessionVariables = {
    # These are the defaults, and xdg.enable does set them, but due to load
    # order, they're not set before environment.variables are set, which could
    # cause race conditions.
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Scripts
    scripts.tmux-sessionizer
    scripts.collect-garbage
    scripts.driverinfo

    # System
    killall
    jq
    libsForQt5.qt5.qtgraphicaleffects # For sddm to function properly
    vulkan-tools
    sddm-themes.astronaut

    # preview image
    qimgv

    # Development
    devbox # faster nix-shells
    shellify # faster nix-shells

    discord
    # TODO: finir le package puis injecter le css dans discord
    # betterdiscord
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix = {
    # Nix Package Manager Settings
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
        "https://nix-gaming.cachix.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = false;
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };
    gc = {
      # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    optimise.automatic = true;
    package = pkgs.nixVersions.stable;
  };
}
