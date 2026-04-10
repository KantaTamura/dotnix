{
  inputs,
  self,
  nixpkgs,
  nix-darwin,
}:
{
  system ? "aarch64-darwin",
  extraModules ? [ ],
}:

nix-darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit inputs self nixpkgs;
  };

  modules = extraModules;
}
