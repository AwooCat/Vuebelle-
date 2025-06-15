{
  description = "JUCHE NixOS + Home Manager (Hyprland)";

  inputs = {
    nixpkgs.url        = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url   = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    system   = "x86_64-linux";
    username = "ryu";
    pkgs     = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    # System (NixOS) configuration
    nixosConfigurations.${username} = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      modules = [
        ./configuration.nix
        ({ config, lib, ... }: {
          services.power-profiles-daemon.enable = true;
          environment.systemPackages = with pkgs; [
            kdePackages.powerdevil
            power-profiles-daemon
            librewolf
            lutris
            steam
            heroic
          ];
          systemd.user.services.set-performance-mode = {
            description     = "Set power profile to balanced";
            wantedBy        = [ "default.target" ];
            serviceConfig.ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced";
          };
          boot.kernelModules = [ "amd_pstate" ];
        })
      ];
    };

    # User (Home Manager) configuration
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs    = pkgs;
      modules = [ ./home.nix ];   # ← exactly this
    };
  };
}
