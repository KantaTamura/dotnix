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
  xdg.dataFile."wallpapers/cat-waves.png".source = self + /wallpapers/catppuccin/cat-waves.png;

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
