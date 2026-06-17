{ ... }:
{
  systemd.tmpfiles.rules = [
    "z /opt 0755 root root -"
  ];
}
