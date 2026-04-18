{ intellijVersion, ... }: {
  home.file.".ideavimrc" = {
    source = ./ideavimrc;
  };
  home.file."Library/Application Support/JetBrains/IntelliJIdea${intellijVersion}/options/editor-font.xml" = {
    source = ./options/editor-font.xml;
    force = true;
  };
  home.file."Library/Application Support/JetBrains/IntelliJIdea${intellijVersion}/options/laf.xml" = {
    source = ./options/laf.xml;
    force = true;
  };
}

