{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  networking.hostName = "ms-a2";
  system.stateVersion = "25.11";
}
