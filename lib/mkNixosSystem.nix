{
  inputs,
  self,
  nixpkgs,
  home-manager,
}:
{
  hostName,
  system ? "x86_64-linux",
  userName ? null,
  homeDirectory ? null,
  extraModules ? [ ],
  extraHomeModules ? [ ],
}:
let
  inherit (nixpkgs) lib;
in
nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit
      inputs
      self
      hostName
      userName
      homeDirectory
      ;
  };

  modules =
    [
      (self + /profiles/nixos/base.nix)
      (self + /hosts/nixos/${hostName})
    ]
    ++ lib.optionals (userName != null) [
      (self + /modules/nixos/users/${userName}.nix)
      home-manager.nixosModules.home-manager
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
