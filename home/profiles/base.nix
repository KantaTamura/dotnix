{ self, ... }:
{
  imports = [
    (self + /modules/common/shell/zsh.nix)
  ];
}
