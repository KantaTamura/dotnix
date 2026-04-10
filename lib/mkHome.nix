{
  inputs,
  self,
  nixpkgs,
  home-manager,
}:
{
  system,
  username,
  homeDirectory,
  extraModules ? [ ],
}:

home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    inherit system;
  };

  extraSpecialArgs = {
    inherit
      inputs
      self
      username
      homeDirectory
      ;
  };

  modules = extraModules;
}
