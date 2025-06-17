{
  description = "Hyprland Gaming NixOS with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      hostname = "nixos";
      username = "ryu";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system pkgs;

        modules = [
          ./configuration.nix

          {
            environment.systemPackages = with pkgs; [
              hyprland
              power-profiles-daemon
              librewolf
              steam
              lutris
              heroic
              fastfetch
              wofi
              firefox
              kdePackages.okular
            ];

            environment.etc."wayland-sessions/hyprland.desktop".text = ''
              [Desktop Entry]
              Name=Hyprland
              Comment=Hyprland Wayland Compositor
              Exec=Hyprland
              Type=Application
              DesktopNames=Hyprland
              TryExec=Hyprland
            '';

            services.power-profiles-daemon.enable = true;
            boot.kernelModules = [ "amd_pstate" ];

            systemd.user.services.set-performance-mode = {
              description = "Set power profile to balanced";
              wantedBy = [ "default.target" ];
              serviceConfig.ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced";
            };
          }
        ];
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        modules = [ ./home.nix ];
      };
    };
}
