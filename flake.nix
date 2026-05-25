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
        inherit inputs self nixpkgs home-manager;
      };
      mkDarwinSystem = import ./lib/mkDarwinSystem.nix {
        inherit inputs self nixpkgs nix-darwin;
      };
      mkHome = import ./lib/mkHome.nix {
        inherit inputs self nixpkgs home-manager;
      };
      mkHomeTestVm = import ./lib/mkHomeTestVm.nix {
        inherit inputs self nixpkgs home-manager;
      };
      homeManagerVm = mkHomeTestVm {
        system = "x86_64-linux";
        hostName = "home-manager-vm";
        userName = "kanta";
        homeDirectory = "/home/kanta";
      };
    in
    {
      nixosConfigurations = {
        ms-a2 = mkNixosSystem {
          system = "x86_64-linux";
          hostName = "ms-a2";
          userName = "kanta";
          homeDirectory = "/home/kanta";
        };
        home-manager-vm = homeManagerVm;
      };

      darwinConfigurations = { };

      homeConfigurations = {
        kanta = mkHome {
          system = "x86_64-linux";
          username = "kanta";
          homeDirectory = "/home/kanta";
          extraModules = [
            ./home/users/kanta
          ];
        };
      };

      packages.x86_64-linux.home-manager-vm = homeManagerVm.config.system.build.vm;
    };
}
