{ config, pkgs, ... }:

{
  home.username      = "ryu";
  home.homeDirectory = "/home/ryu";

  programs.home-manager.enable = true;
  wayland.windowManager.hyprland.enable = true;

  home.packages = with pkgs; [
    alacritty
    waybar
    swaylock
    git
    vim
    zsh
  ];

  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
  };

  programs.zsh = {
    enable       = true;
    shellAliases = { ll = "ls -al"; gs = "git status"; };
  };

  home.stateVersion = "23.05";
}
