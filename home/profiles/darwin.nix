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

  xdg.configFile."karabiner/karabiner.json" = {
    source = configDir + "/karabiner/karabiner.json";
    force = true;
  };
}
