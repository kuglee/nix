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
    initLua = ''
      require("full-border"):setup {
        type = ui.Border.ROUNDED,
      }
    '';
    plugins = {
      compress = pkgs.fetchFromGitHub {
        owner = "KKV9";
        repo = "compress.yazi";
        rev = "80e5268"; 
        hash = "sha256-9cdA8D/TtwHcLqrtoyIixA0YJmTs+c8FSNrjxp8CYI0=";
      };
      what-size = pkgs.fetchFromGitHub {
        owner = "pirafrank";
        repo = "what-size.yazi";
        rev = "ec94d9a"; 
        hash = "sha256-slM9qypEy8A4l3KodE7bmyixA+1c4X7hgoGcQP7R25k=";
      };
      system-clipboard = pkgs.yaziPlugins.clipboard;
      full-border = pkgs.yaziPlugins.full-border;
    };
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
    keymap = {
      mgr.prepend_keymap = [
        {
          on   = [ "c" "s" ];
          run  = "plugin what-size";
          desc = "Calc size of selection or cwd";
        }
        {
          on   = [ "c" "a" "a" ];
          run  = "plugin compress";
          desc = "Archive selected files";
        }
        {
          on   = [ "c" "a" "p" ];
          run  = "plugin compress -p";
          desc = "Archive selected files (password)";
        }
        {
          on   = [ "c" "a" "h" ];
          run  = "plugin compress -ph";
          desc = "Archive selected files (password+header)";
        }
        {
          on   = [ "c" "a" "l" ];
          run  = "plugin compress -l";
          desc = "Archive selected files (compression level)";
        }
        {
          on   = [ "c" "a" "u" ];
          run  = "plugin compress -phl";
          desc = "Archive selected files (password+header+level)";
        }
        {
          on   = "y";
          run  = [ "yank" "plugin system-clipboard -- --action=copy" ];
          desc = "Yank selected files to system clipboard (copy)";
        }
        {
          on   = "x";
          run  = [ "yank --cut" "plugin system-clipboard -- --action=copy" ];
          desc = "Yank selected files to system clipboard (cut)";
        }
        {
          on   = "<C-p>";
          run  = [ "plugin system-clipboard -- --action=paste" ];
          desc = "Paste yanked system clipboard files";
        }
      ];
    };
  };
}
