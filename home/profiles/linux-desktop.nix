{ self, ... }:
let
  configDirs = [
    "fcitx5"
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
  xdg.dataFile."fcitx5/themes/catppuccin-mocha-lavender".source =
    self + /themes/fcitx5/catppuccin-mocha-lavender;

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
