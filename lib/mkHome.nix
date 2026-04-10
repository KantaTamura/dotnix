{
  inputs,
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
      username
      homeDirectory
      ;
  };

  modules = extraModules;
}
