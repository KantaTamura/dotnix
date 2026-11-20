{ self, ... }:
let
  configDirs = [
    "hypr"
    "waybar"
    "rofi"
    "mako"
    "wlogout"
    "xdg-desktop-portal"
  ];
in
{
  # Desktop applications and services are provided by the host distribution.
  xdg.configFile = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = {
        source = self + "/config/${name}";
        recursive = true;
      };
    }) configDirs
  );
}
