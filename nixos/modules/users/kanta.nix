{ pkgs, ... }:
{
  users.users.kanta = {
    isNormalUser = true;
    description = "Kanta Tamura";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUXZIigZ+berBnrBxykvRe9Sn6D+URl7gy+cRDVxJqv"
    ];
  };
}
