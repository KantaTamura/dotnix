{
  self,
  username,
  homeDirectory,
  ...
}:
{
  imports = [
    (self + /home/profiles/base.nix)
  ];

  home = {
    inherit username homeDirectory;
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
