{ ... }:
{
  networking.networkmanager.enable = true;

  networking.extraHosts = ''
    127.0.0.1 localhost
    ::1 localhost
    127.0.1.1 ms-a2.localdomain ms-a2
  '';

  networking.interfaces.enp3s0.ipv4.addresses = [
    {
      address = "192.168.10.3";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.10.1";
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];
}
