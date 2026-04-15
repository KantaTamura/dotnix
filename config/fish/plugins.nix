{ pkgs }:
[
  {
    name = "autopair";
    src = pkgs.fishPlugins.autopair.src;
  }
  {
    name = "plugin-git";
    src = pkgs.fishPlugins.plugin-git.src;
  }
  {
    name = "fzf-fish";
    src = pkgs.fishPlugins.fzf-fish.src;
  }
  {
    name = "sponge";
    src = pkgs.fishPlugins.sponge.src;
  }
  {
    name = "bass";
    src = pkgs.fishPlugins.bass.src;
  }
  {
    name = "foreign-env";
    src = pkgs.fishPlugins.foreign-env.src;
  }
]
