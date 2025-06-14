{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use kernel 6.1 for newer NVIDIA support
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  # Prevent conflict with nouveau
  boot.blacklistedKernelModules = [ "nouveau" ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Brazzaville";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Keyboard layout: Swiss German
  console.keyMap = "sg";

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;

  # Enable Steam client
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    firefox
    pciutils

    # Gaming packages (no flatpak)
    steam-run
    heroic
    runelite
    lutris
    mangohud

    # Wine and winetricks for Windows games
    wine
    wineWowPackages.staging
    winetricks

    # Fastfetch for CLI system info
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
    open = false;  # Use proprietary NVIDIA driver
    prime = {
      offload.enable = true;
      amdgpuBusId = "PCI:5:0:0";  # Adjust for your AMD GPU
      nvidiaBusId = "PCI:1:0:0";  # Adjust for your NVIDIA GPU
    };
  };

  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";

    # Fix protobuf python errors in Lutris/Battle.net scripts
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

  system.stateVersion = "25.05";
}
