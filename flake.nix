{
  description = "JUCHE NixOS configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.JUCHE = nixpkgs.lib.nixosSystem {
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
            description = "Set power profile to balanced";
            wantedBy = [ "default.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced";
            };
          };

          boot.kernelModules = [ "amd_pstate" ];
        })
      ];
    };
  };
}
