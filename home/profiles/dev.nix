{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang
    clang-tools
    cmake
    docker-compose
    go
    lua-language-server
    luarocks
    nixd
    nodejs
    openssl
    rustup
    uv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
