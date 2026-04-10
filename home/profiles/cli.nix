{ config, pkgs, ... }:
{
  xdg.enable = true;

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

  programs.starship.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.path = "${config.xdg.stateHome}/zsh/history";
  };
}
