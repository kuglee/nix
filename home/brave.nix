{ pkgs, ... }:

{
  programs.brave = {
    enable = true;
    extensions = [
      { id = "edlhclhffmclbhgifomamlomnfolnepa"; } # Elm Debug Helper
      { id = "pejdijmoenmkgeppbflobdenhhabjlaj"; } # iCloud-passwords
    ];
  };
}
