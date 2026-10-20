{ self, hostName, ... }:
{
  imports = [
    (self + /hosts/nixos/${hostName}/hardware-configuration.nix)
    (self + /hosts/nixos/${hostName}/networking.nix)
  ];

  networking.hostName = hostName;
  networking.enableIPv6 = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Home Assistant uses host networking to discover devices on the LAN.
  virtualisation.oci-containers = {
    backend = "docker";
    containers.matter-server = {
      image = "ghcr.io/matter-js/matterjs-server:1.4.0";
      autoStart = true;
      environment = {
        TZ = "Asia/Tokyo";
        STORAGE_PATH = "/data";
        LISTEN_ADDRESS = "127.0.0.1";
        PRIMARY_INTERFACE = "enp3s0";
      };
      volumes = [ "/var/lib/matter-server:/data" ];
      extraOptions = [
        "--network=host"
        "--stop-timeout=60"
      ];
    };
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
    wants = [
      "bluetooth.service"
      "docker-matter-server.service"
    ];
    after = [
      "bluetooth.service"
      "dbus.service"
      "docker-matter-server.service"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/home-assistant 0700 root root -"
    "d /var/lib/home-assistant/themes 0755 root root -"
    # The upstream Matter.js image runs as UID/GID 1000.
    "d /var/lib/matter-server 0700 1000 1000 -"
  ];

  networking.firewall = {
    interfaces.enp3s0 = {
      allowedTCPPorts = [ 8123 ];
      allowedUDPPorts = [ 5353 ];
    };
    # Matter controllers use dynamic UDP ports for link-local communication.
    extraCommands = ''
      ip6tables -A nixos-fw -i enp3s0 -s fe80::/10 -p udp -j nixos-fw-accept
    '';
    extraStopCommands = ''
      ip6tables -D nixos-fw -i enp3s0 -s fe80::/10 -p udp -j nixos-fw-accept 2>/dev/null || true
    '';
  };

  system.stateVersion = "25.11";
}
