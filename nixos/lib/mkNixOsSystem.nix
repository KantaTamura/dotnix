/*
  mkNixOsSystem

  Helper function to create a NixOS system configuration.

  Usage (in flake.nix):

  ```
    let
      mkNixOsSystem = import ./nixos/lib/mkNixOsSystem.nix { inherit nixpkgs; };
    in
    {
      nixosConfigurations = {
        ms-a2 = mkNixOsSystem {
          hostName = "ms-a2";
        };

        # With additional modules
        devbox = mkNixosSystem {
          hostName = "devbox";
          extraModules = [
            ./nixos/modules/dev-tools.nix
          ];
        };
      };
    };
  ```

  Arguments:
    hostName      Name of the host under nixos/hosts/<hostName>
    system        Target system (default: "x86_64-linux")
    extraModules  Additional NixOS modules appended to the module list
*/
{
  inputs,
  self,
  nixpkgs,
}:
{
  hostName,
  system ? "x86_64-linux",
  extraModules ? [ ],
}:

nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit
      inputs
      self
      hostName
      ;
  };

  modules = [
    ../modules/base.nix
    ../modules/locale-ja.nix
    ../modules/zram.nix
    ../modules/openssh-hardening.nix
    ../modules/users/kanta.nix

    ../hosts/${hostName}
  ]
  ++ extraModules;
}
