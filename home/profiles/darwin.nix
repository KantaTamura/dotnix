{ self, ... }:
let
  configDir = self + /config;
in
{
  xdg.configFile.aerospace = {
    source = configDir + "/aerospace";
    recursive = true;
  };
}
