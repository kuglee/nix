{ intellijVersion, lib, ... }:
let
  basePath = "Library/Application Support/JetBrains/IntelliJIdea${intellijVersion}";

  optionFiles = [
    "advancedSettings.xml"
    "AIOnboardingPromoWindowAdvisor.xml"
    "colors.scheme.xml"
    "editor-font.xml"
    "editor.xml"
    "ide.general.xml"
    "laf.xml"
    "ui.lnf.xml"
    "vim_settings.xml"
  ];

  codestyleFiles = [
    "Default.xml"
  ];

  mkFiles = subdir: files:
    lib.listToAttrs (map (name: {
      name = "${basePath}/${subdir}/${name}";
      value = {
        source = ./. + "/${subdir}/${name}";
        force = true;
      };
    }) files);
in
{
  home.file =
    { ".ideavimrc".source = ./ideavimrc; }
    // mkFiles "options" optionFiles
    // mkFiles "codestyles" codestyleFiles;
}
