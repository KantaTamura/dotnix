{ self, ... }:
{
  imports = [
    (self + /home/profiles/cli.nix)
    (self + /home/profiles/dev.nix)
  ];
}
