{ config, pkgs, ... }:

{
  # A relogin is needed for the keyboard layout to activate
  home.activation.copyKeyboardLayout = ''
    cp -f ${./keyboard-layout.keylayout} ~/Library/Keyboard\ Layouts/keyboard-layout.keylayout
  '';
}

