{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_6_1;
  boot.blacklistedKernelModules = [ "nouveau" ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Brazzaville";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Console (TTY) keyboard layout
  console.keyMap = "sg";  # For Swiss German on console

  # X11 keyboard layout (GUI)
  services.xserver.enable = true;
  services.xserver.xkb.layout = "ch";
  services.xserver.xkb.variant = "de";
  services.xserver.videoDrivers = [ "nvidia" ];

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    firefox
    pciutils
    steam-run
    heroic
    runelite
    lutris
    mangohud
    wine
    wineWowPackages.staging
    winetricks
    fastfetch
  ];

  programs.zsh.enable = true;

  users.users.ryu = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    open = false;
    prime = {
      offload.enable = true;
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

  system.stateVersion = "25.05";
}
