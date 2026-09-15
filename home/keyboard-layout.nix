{ config, pkgs, ... }:

{
  # A relogin is needed for the keyboard layout to activate
  home.activation.copyKeyboardLayout = ''
    mkdir -p ~/Library/Keyboard\ Layouts
    cp -f ${./keyboard-layout.keylayout} ~/Library/Keyboard\ Layouts/keyboard-layout.keylayout
  '';
}

