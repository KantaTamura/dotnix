{ self, hostName, ... }:
{
  imports = [
    (self + /hosts/nixos/${hostName}/hardware-configuration.nix)
    (self + /hosts/nixos/${hostName}/networking.nix)
  ];

  networking.hostName = hostName;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Home Assistant uses host networking to discover devices on the LAN.
  virtualisation.oci-containers = {
    backend = "docker";
    containers.home-assistant = {
      image = "ghcr.io/home-assistant/home-assistant:2026.10.2";
      autoStart = true;
      environment.TZ = "Asia/Tokyo";
      volumes = [
        "/var/lib/home-assistant:/config"
        "/run/dbus:/run/dbus:ro"
      ];
      # Bluetooth discovery and adapter recovery through the host's BlueZ.
      capabilities = {
        NET_ADMIN = true;
        NET_RAW = true;
      };
      extraOptions = [
        "--network=host"
        "--stop-timeout=60"
      ];
    };
  };

  systemd.services.docker-home-assistant = {
    wants = [ "bluetooth.service" ];
    after = [
      "bluetooth.service"
      "dbus.service"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/home-assistant 0700 root root -"
    "d /var/lib/home-assistant/themes 0755 root root -"
  ];

  networking.firewall.interfaces.enp3s0.allowedTCPPorts = [ 8123 ];

  system.stateVersion = "25.11";
}
