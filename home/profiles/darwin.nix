{ self, pkgs, ... }:
let
  configDir = self + /config;
  sketchybarLua = pkgs.lua5_5.withPackages (_: [ pkgs.sbarlua ]);
in
{
  home.packages = [ sketchybarLua ];

  xdg.configFile.aerospace = {
    source = configDir + "/aerospace";
    recursive = true;
  };

  xdg.configFile.sketchybar = {
    source = configDir + "/sketchybar";
    recursive = true;
  };

  xdg.configFile."dynamic-island-sketchybar/userconfig.sh".source =
    configDir + "/dynamic-island-sketchybar/userconfig.sh";
}
