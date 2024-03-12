# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "uas" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/347d01e2-aec3-4525-bee3-3dbdec585399";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9C97-F7D4";
    fsType = "vfat";
  };

  swapDevices = [];

  fileSystems."/mnt/seagate" = {
    device = "/dev/disk/by-uuid/E212-7894";
    fsType = "auto";
    options = [
      "X-mount.mkdir"
      "async"
      "auto"
      "dev"
      "user"
      "rw"
      "exec"
      "suid"
      "nofail"
      "uid=1000"
      "gid=100"
      "umask=000"
      "x-gvfs-show"
      "x-systemd.automount"
      "x-systemd.mount-timeout=5"
    ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/01DA12C1CBDE9100";
    fsType = "lowntfs-3g";
    options = [
      "X-mount.mkdir"
      "nofail"
      "async"
      "rw"
      "exec"
      "user"
      "uid=1000"
      "gid=100"
      "umask=000"
      "x-gvfs-show"
      "x-systemd.mount-timeout=5"
    ];
  };

  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
