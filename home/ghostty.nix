{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package=pkgs.ghostty-bin;

    settings = {
      # Theme configuration
      theme = "light:TokyoNight Day,dark:TokyoNight";

      # Window settings
      window-padding-color = "extend-always";

      # Font configuration
      font-family = "Liga SFMono Nerd Font";
      font-size = 12;
      adjust-cell-height = 10;

      # Shell integration
      shell-integration-features = [ "ssh-env" "no-cursor" ];

      # Cursor settings
      cursor-style = "block";
      cursor-style-blink = false;

      # Split window settings
      unfocused-split-opacity = 1;

      # Mouse behavior
      mouse-hide-while-typing = true;

      # Keybindings
      keybind = [
        "cmd+s=text:\\x13"
        "cmd+a=text:\\x01"
      ];
    };
  };
}
