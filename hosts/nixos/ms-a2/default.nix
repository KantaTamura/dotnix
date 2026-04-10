{ self, hostName, ... }:
{
  imports = [
    (self + /hosts/nixos/${hostName}/hardware-configuration.nix)
    (self + /hosts/nixos/${hostName}/networking.nix)
  ];

  networking.hostName = hostName;
  system.stateVersion = "25.11";
}
