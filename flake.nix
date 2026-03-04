{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      mkNixOsSystem = import ./nixos/lib/mkNixOsSystem.nix { inherit nixpkgs; };
    in
    {
      nixosConfigurations = {
        ms-a2 = mkNixOsSystem {
          hostName = "ms-a2";
        };
      };
    };
}
