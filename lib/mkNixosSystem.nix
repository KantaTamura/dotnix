{
  inputs,
  self,
  nixpkgs,
}:
{
  hostName,
  system ? "x86_64-linux",
  extraModules ? [ ],
}:

nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit
      inputs
      self
      hostName
      ;
  };

  modules = [
    (self + /nixos/modules/base.nix)
    (self + /nixos/modules/locale-ja.nix)
    (self + /nixos/modules/zram.nix)
    (self + /nixos/modules/docker.nix)
    (self + /nixos/modules/tailscale.nix)
    (self + /nixos/modules/openssh-hardening.nix)
    (self + /nixos/modules/users/kanta.nix)

    (self + /nixos/hosts/${hostName})
  ]
  ++ extraModules;
}
