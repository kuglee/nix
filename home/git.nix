{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Gábor Librecz";
        email = "kuglee@gmail.com";
      };

      log = {
        date = "iso";
      };

      format = {
        pretty = "format:%Cred%h%Creset %Cgreen%cd%Creset %<(60,trunc)%s %C(bold black)%<(20,trunc)%an%Creset %C(yellow)%d%Creset";
      };

      # from: https://blog.gitbutler.com/how-git-core-devs-configure-git

      tag = {
        sort = "version:refname";
      };

      init = {
        defaultBranch = "main";
      };

      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };

      push = {
        autoSetupRemote = true;
        followTags = true;
      };

      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };

      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };

      merge = {
        conflictstyle = "zdiff3";
      };

      core = {
        autocrlf = "input";
      };
    };
  };
}
