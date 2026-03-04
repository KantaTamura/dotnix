{ self, hostName, ... }:
{
  imports = [
    (self + /nixos/hosts/${hostName}/hardware-configuration.nix)
    (self + /nixos/hosts/${hostName}/networking.nix)
  ];

  networking.hostName = hostName;
  system.stateVersion = "25.11";
}
