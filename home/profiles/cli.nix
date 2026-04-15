{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  configDir = self + /config;
  recursiveConfigDirs = [
    "nvim"
    "zsh"
  ];
  configFiles = [
    "sheldon/plugins.toml"
    "starship.toml"
  ];
  mkRecursiveConfigEntry = name: {
    name = name;
    value = {
      source = configDir + "/${name}";
      recursive = true;
    };
  };
  mkConfigFileEntry = name: {
    name = name;
    value.source = configDir + "/${name}";
  };
in
{
  xdg.enable = true;

  xdg.configFile =
    builtins.listToAttrs (map mkRecursiveConfigEntry recursiveConfigDirs)
    // builtins.listToAttrs (map mkConfigFileEntry configFiles);

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  home.packages = with pkgs; [
    curl
    fastfetch
    fd
    gettext
    gnumake
    ninja
    pkg-config
    ripgrep
    sheldon
    sqlite
    starship
    tree-sitter
    unzip
  ];

  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
  };

  programs.fd.enable = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.home-manager.enable = true;

  programs.lazygit.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = false;
    enableZshIntegration = false;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile (configDir + "/fish/config.fish");
    plugins = import (configDir + "/fish/plugins.nix") { inherit pkgs; };
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history.path = "${config.xdg.stateHome}/zsh/history";
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        mkdir -p ${config.xdg.stateHome}/zsh
        eval "$(sheldon source)"
      '')
      ''
        source ${config.xdg.configHome}/zsh/config.zsh
      ''
    ];
  };
}
