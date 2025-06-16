{ config, pkgs, ... }:

let
  # Waybar config JSON inlined as a string
  waybarConfig = ''
    {
      "layer": "top",
      "position": "top",
      "modules-left": ["sway/workspaces", "sway/mode"],
      "modules-center": ["clock"],
      "modules-right": ["cpu", "memory", "temperature", "battery", "network"],
      "cpu": {
        "format": "{usage}%"
      },
      "memory": {
        "format": "{used}MB / {total}MB"
      },
      "temperature": {
        "format": "{temperature}°C"
      }
    }
  '';
in

{
  home.username = "ryu";
  home.homeDirectory = "/home/ryu";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    alacritty
    waybar
    swaylock
    git
    vim
    zsh
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    catppuccin-gtk
    hyprpaper
  ];

  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -al";
      gs = "git status";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, RETURN, exec, alacritty"
        "$mod, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod SHIFT, E, exit,"
      ];

      exec-once = [
        "hyprpaper"
        "waybar"
      ];

      monitor = [ ",preferred,auto,1,wallpaper=${toString /home/ryu/.config/hypr/wallpapers/1340419.png},wallpaper_mode=fill" ];

      env = [
        "XCURSOR_SIZE,24"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(ff00ffaa)";
        "col.inactive_border" = "rgba(1a1a1aaa)";
      };
    };
  };

  programs.waybar = {
    enable = true;
  };

  # Inline Waybar config as a file in home directory
  home.file.".config/waybar/config" = {
    text = waybarConfig;
  };

  # Disable nixpkgs release check warning (optional)
  home.enableNixpkgsReleaseCheck = false;
}
