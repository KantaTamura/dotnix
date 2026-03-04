{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      mkNixOsSystem = import ./nixos/lib/mkNixOsSystem.nix {
        inherit inputs self nixpkgs;
      };
    in
    {
      nixosConfigurations = {
        ms-a2 = mkNixOsSystem {
          system = "x86_64-linux";
          hostName = "ms-a2";
        };
      };
    };
}
