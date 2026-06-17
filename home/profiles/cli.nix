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
    "lazygit"
    "nvim"
    "wezterm"
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
    codex
    curl
    fastfetch
    fd
    gettext
    gh
    gnumake
    ninja
    osc
    pkg-config
    ripgrep
    sheldon
    sqlite
    starship
    tree-sitter
    unzip
    wget
    wezterm
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
    ignores = [
      "*.local.*"
      "*.local"
      ".env"
      ".envrc"
      ".direnv"
      ".idea"
      ".cache/clangd"
      "compile_commands.json"
      ".codex"
    ];
    includes = [
      {
        condition = "gitdir:~/workspace/sc/";
        contents.user = {
          email = "kanta@spacecubics.com";
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLa9WJb1UliLViRw8bNRKVyx2RccvDkOmkiePPPg6Bx";
        };
      }
    ];
    lfs.enable = true;
    settings = {
      user = {
        name = "KantaTamura";
        email = "tkanta496@gmail.com";
      };
      color.ui = "auto";
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        pager = "delta";
      };
      fetch.prune = true;
      pull.rebase = true;
      merge.conflictstyle = "zdiff3";
      "credential \"https://github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      "credential \"https://gist.github.com\"".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      credential.helper = "store";
      alias = {
        loggraph = "log --graph --color=always --date=format:'%Y-%m-%d %H:%M' --pretty=format:'%C(#a0a0a0 reverse)%h%Creset %C(cyan)%ad%Creset %C(#dd4814)%ae%Creset %C(yellow reverse)%d%Creset%n%C(white bold)%s%Creset%n";
        zip = ''!"TOPDIR=$(basename $(git rev-parse --show-toplevel)) && git archive HEAD --prefix=\"$TOPDIR\"/ --output=\"$TOPDIR\".zip'';
      };
    };
    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICj1XLN1IL30Mm5T4VT6htUJTfKQpQ/Hx21kW+tBIqTq";
      signByDefault = true;
      signer =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else
          "/opt/1Password/op-ssh-sign";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.home-manager.enable = true;

  programs.lazygit.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "~/.ssh/config.local"
    ];
    settings."*" = {
      ServerAliveInterval = 60;
      TCPKeepAlive = true;
      ForwardAgent = true;
      SetEnv.TERM = "xterm-256color";
      IdentityFile = "~/.ssh/1password.pub";
    };
    extraConfig = ''
      Match exec "test -z $SSH_CONNECTION"
          IdentityAgent ${
            if pkgs.stdenv.hostPlatform.isDarwin then
              "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
            else
              "~/.1password/agent.sock"
          }
    '';
  };

  home.activation.ensureSshConfigLocal = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    install -d -m 700 "${config.home.homeDirectory}/.ssh"
    if [ ! -e "${config.home.homeDirectory}/.ssh/config.local" ] && [ ! -L "${config.home.homeDirectory}/.ssh/config.local" ]; then
      install -m 600 /dev/null "${config.home.homeDirectory}/.ssh/config.local"
    fi
  '';

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
        ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
          HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
        ''}
        eval "$(sheldon source)"
      '')
      ''
        source ${config.xdg.configHome}/zsh/config.zsh
      ''
    ];
  };
}
