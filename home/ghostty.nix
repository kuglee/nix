{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package=pkgs.ghostty-bin;

    settings = {
      # Update settings
      auto-update = "off";

      # Theme configuration
      theme = "light:TokyoNight Day,dark:TokyoNight";

      # Window settings
      window-padding-color = "extend-always";

      # Font configuration
      font-family = "Monaspace Neon NF";
      font-family-bold = "Monaspace Xenon NF";
      font-family-italic = "Monaspace Radon NF";
      font-family-bold-italic = "Monaspace Krypton NF";

      # The following are optional settings for more balanced font weight
      font-style = "Medium";
      font-style-bold = "Regular";
      font-style-italic= "Italic";
      font-style-bold-italic = "Bold";

      # see: https://github.com/githubnext/monaspace?tab=readme-ov-file#coding-ligatures
      font-feature = "ss01, ss02, ss03, ss04, ss05, ss06, ss07, ss08, ss09, cv01 2, cv31 1, cv10";

      font-size = 12;
      adjust-cell-height = 10;

      # Shell integration
      shell-integration-features = "ssh-env, no-cursor";

      # Cursor settings
      cursor-style = "block";
      cursor-style-blink = false;

      # Split window settings
      unfocused-split-opacity = 1;

      # Mouse behavior
      mouse-hide-while-typing = true;

      # Start new windows in fullscreen
      fullscreen = true;

      # Keybindings
      keybind = [
        "cmd+s=text:\\x13"
        "cmd+a=text:\\x01"
      ];
    };
  };
}
