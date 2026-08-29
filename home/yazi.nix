{ pkgs, ... }:

let
  tokyoNightRepo = pkgs.fetchFromGitHub {
    owner = "kalidyasin";
    repo = "yazi-flavors";
    rev = "bfd1b37";
    hash = "sha256-j9MCWSK8Xnj3mlbeQZcxkZ+wWQU+CCJfS39Tp8zextE="; 
  };
in
{
  programs.yazi = {
    enable = true;
    flavors = {
      tokyonight-night = tokyoNightRepo + "/tokyonight-night.yazi";
      tokyonight-day = tokyoNightRepo + "/tokyonight-day.yazi";
    };
    theme.flavor = {
      dark  = "tokyonight-night";
      light = "tokyonight-day";
    };
    settings = {
      mgr = {
        sort_dir_first = false;
      };
      preview = {
        max_width = 1100;
        max_height = 1400;
      };
      preloaders = [];
    };
  };
}
