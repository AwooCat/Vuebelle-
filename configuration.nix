{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_1;
  boot.blacklistedKernelModules = [ "nouveau" ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Brazzaville";
  i18n.defaultLocale = "en_GB.UTF-8";

  console.keyMap = "sg";

  services.xserver.enable = false;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;  # Correctly enable SDDM Wayland support
  };

  services.desktopManager.plasma6.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  users.users.ryu = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.steam.enable = true;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    open = false;
    prime = {
      offload.enable = true;
      amdgpuBusId = "PCI:5:0:0";   # Your AMD GPU PCI bus ID
      nvidiaBusId = "PCI:1:0:0";   # Your NVIDIA GPU PCI bus ID
    };
  };

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  system.stateVersion = "25.05";
}
