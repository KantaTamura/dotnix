{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      mkNixosSystem = import ./lib/mkNixosSystem.nix {
        inherit inputs self nixpkgs;
      };
      mkDarwinSystem = import ./lib/mkDarwinSystem.nix {
        inherit inputs self nixpkgs nix-darwin;
      };
      mkHome = import ./lib/mkHome.nix {
        inherit inputs nixpkgs home-manager;
      };
    in
    {
      nixosConfigurations = {
        ms-a2 = mkNixosSystem {
          system = "x86_64-linux";
          hostName = "ms-a2";
        };
      };

      darwinConfigurations = { };

      homeConfigurations = { };
    };
}
