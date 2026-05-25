{
  inputs,
  self,
  nixpkgs,
  home-manager,
}:
{
  system ? "x86_64-linux",
  hostName ? "home-manager-vm",
  userName,
  homeDirectory,
  extraHomeModules ? [ ],
}:
nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit
      inputs
      self
      hostName
      userName
      homeDirectory
      ;
  };

  modules = [
    ({ modulesPath, pkgs, ... }: {
      imports = [
        (modulesPath + "/virtualisation/qemu-vm.nix")
        home-manager.nixosModules.home-manager
        (self + /modules/common/core.nix)
        (self + /modules/common/nix.nix)
        (self + /modules/common/shell/zsh.nix)
        (self + /modules/nixos/i18n/locale-ja.nix)
      ];

      networking.hostName = hostName;
      system.stateVersion = "25.11";

      users.users.${userName} = {
        isNormalUser = true;
        description = userName;
        extraGroups = [ "wheel" ];
        initialPassword = "nixos";
        shell = pkgs.zsh;
      };

      services.getty.autologinUser = userName;

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          self
          homeDirectory
          ;
        username = userName;
      };
      home-manager.users.${userName} = {
        imports = [
          (self + /home/users/${userName})
        ] ++ extraHomeModules;
      };

      virtualisation = {
        memorySize = 4096;
        cores = 2;
        graphics = false;
        forwardPorts = [
          {
            from = "host";
            host.port = 2222;
            guest.port = 22;
          }
        ];
      };

      documentation.enable = false;
      services.openssh.enable = true;
    })
  ];
}
