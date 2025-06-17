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
      hostname = "nixos";  # Adjust if your hostname is different
      username = "ryu";    # Adjust if your user is different

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
            # Set Hyprland as the default session
            services.displayManager.defaultSession = "hyprland";
            services.displayManager.sessionPackages = [ pkgs.hyprland ];

            # Packages
            environment.systemPackages = with pkgs; [
              hyprland
              power-profiles-daemon
              librewolf
              steam
              lutris
              heroic
            ];

            # Enable power profile control
            services.power-profiles-daemon.enable = true;
            boot.kernelModules = [ "amd_pstate" ];

            # Set power mode to balanced on user login
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
