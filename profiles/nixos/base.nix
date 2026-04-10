{ self, ... }:
{
  imports = [
    (self + /modules/common/core.nix)
    (self + /modules/common/nix.nix)
    (self + /modules/common/shell/zsh.nix)
    (self + /modules/nixos/boot/efi-systemd-boot.nix)
    (self + /modules/nixos/i18n/locale-ja.nix)
    (self + /modules/nixos/services/docker.nix)
    (self + /modules/nixos/services/openssh-hardening.nix)
    (self + /modules/nixos/services/tailscale.nix)
    (self + /modules/nixos/system/zram.nix)
  ];
}
