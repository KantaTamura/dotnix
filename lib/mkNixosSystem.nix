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
    (self + /profiles/nixos/base.nix)
    (self + /nixos/modules/users/kanta.nix)
    (self + /hosts/nixos/${hostName})
  ]
  ++ extraModules;
}
