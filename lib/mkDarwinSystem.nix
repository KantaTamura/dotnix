{
  inputs,
  self,
  nixpkgs,
  nix-darwin,
  home-manager,
}:
{
  hostName,
  system ? "aarch64-darwin",
  userName,
  homeDirectory,
  extraModules ? [ ],
  extraHomeModules ? [ ],
}:
let
  inherit (nixpkgs) lib;
in
nix-darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit
      inputs
      self
      hostName
      userName
      homeDirectory
      nixpkgs
      ;
  };

  modules = [
    (self + /profiles/darwin/base.nix)
    (self + /hosts/darwin/${hostName})
  ]
  ++ lib.optionals (userName != null) [
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          self
          userName
          homeDirectory
          ;
        username = userName;
      };
      home-manager.users."${userName}" = {
        imports = [
          (self + /home/users/${userName})
        ]
        ++ extraHomeModules;
      };
    }
  ]
  ++ extraModules;
}
