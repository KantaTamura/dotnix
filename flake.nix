{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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
      flake-utils,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      eachSystem = flake-utils.lib.eachSystem supportedSystems;

      mkNixosSystem = import ./lib/mkNixosSystem.nix {
        inherit
          inputs
          self
          nixpkgs
          home-manager
          ;
      };
      mkDarwinSystem = import ./lib/mkDarwinSystem.nix {
        inherit
          inputs
          self
          nixpkgs
          nix-darwin
          home-manager
          ;
      };
      mkHome = import ./lib/mkHome.nix {
        inherit
          inputs
          self
          nixpkgs
          home-manager
          ;
      };
    in
    eachSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        mkHomeTestVm = import ./lib/mkHomeTestVm.nix {
          inherit
            inputs
            self
            nixpkgs
            home-manager
            ;
        };
      in
      {
        formatter = pkgs.nixfmt-tree;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        packages.home-manager-vm =
          (mkHomeTestVm {
            inherit system;
            hostName = "home-manager-vm";
            userName = "kanta";
            homeDirectory = "/home/kanta";
          }).config.system.build.vm;
      }
    )
    // {
      nixosConfigurations = {
        ms-a2 = mkNixosSystem {
          system = "x86_64-linux";
          hostName = "ms-a2";
          userName = "kanta";
          homeDirectory = "/home/kanta";
        };
      };

      darwinConfigurations = {
        macbook = mkDarwinSystem {
          system = "aarch64-darwin";
          hostName = "macbook";
          userName = "kanta";
          homeDirectory = "/Users/kanta";
        };
      };

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
    };
}
