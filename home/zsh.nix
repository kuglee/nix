{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    setOptions = [
      "BANG_HIST"
      "HIST_VERIFY"
      "HIST_BEEP"
      "MENU_COMPLETE"
      "AUTOCD"
      "NO_CORRECT"
    ];

    # History configuration
    history = {
      size = 10000;
      save = 10000;
      extended = true;
      share = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
    };
    historySubstringSearch.enable = true;

    # Completion settings
    enableCompletion = true;
    autosuggestion.enable = true;

    # Shell aliases
    shellAliases = {
      ls = "ls -G";
      rg = "rg -i";
      reloadprefs = "sudo killall cfprefsd";

      # yt-dlp aliases
      yt-dlp-mp4 = ''yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" -S vcodec:h264 --restrict-filename -o "%(title).150B-[%(id)s].%(ext)s"'';
      yt-dlp-1080 = ''yt-dlp -f "bestvideo[ext=mp4][height<=1080]+bestaudio[ext=m4a]/best[ext=mp4]" -S vcodec:h264 --restrict-filenames -o "%(title).150B-[%(id)s].%(ext)s"'';
      yt-dlp-1080-date = ''yt-dlp -f "bestvideo[ext=mp4][height<=1080]+bestaudio[ext=m4a]/best[ext=mp4]" -S vcodec:h264 --restrict-filenames -o "%(title).150B-[%(id)s]-%(upload_date)s.%(ext)s"'';

      # Interactive flags
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";

      # Nix-darwin
      darwin-switch="sudo darwin-rebuild switch --flake ~/.config/nix#macbook";
    };

    # Local variables (prompt, etc)
    localVariables = {
      PS1 = "$ ";
    };

    siteFunctions = {
      # macOS Finder integration
      pfd = ''
        osascript -l JavaScript 2>/dev/null <<EOF
          const finder = Application('Finder')
          if (finder.windows.length > 0) {
            return finder.insertionLocation().url().slice(7)
          }
        EOF
      '';

      cdf = ''
        cd "$(pfd)"
      '';

      # backup BetterTouchTool settings
      backupBttSettings = ''
        osascript -l JavaScript 2>/dev/null <<EOF
          Application("BetterTouchTool").export_preset("config", { 
            outputpath: "~/.config/nix/home/betterTouchTool/config.bttpreset",
            includesettings: true 
          });
        EOF
      '';

      # from: https://github.com/thanhdevapp/jetbrains-reset-trial-evaluation-mac
      reset-intellij-eval = ''
        setopt NULL_GLOB
        rm -rf ~/"Library/Application Support/JetBrains/IntelliJIdea"*/eval/*.key
        sed -i "" '/evlsprt/d' ~/"Library/Application Support/JetBrains/IntelliJIdea"*/options/other.xml
        rm -f ~/Library/Preferences/com.apple.java.util.prefs.plist
        rm -f ~/Library/Preferences/com.jetbrains.*.plist
        rm -f ~/Library/Preferences/jetbrains.*.*.plist
        for f in ~/Library/Preferences/jetbrains.*.plist; do
            if [[ -f $f ]]; then
                fn=''${f##*/}; key=''${fn%.plist}
                defaults delete "''${fn%.plist}" 2>/dev/null && rm "$f"
            fi
        done
        killall cfprefsd
      '';
    };

    # Init commands (additional configuration)
    initContent = ''
      # Completion styles
      zstyle ':completion:*:manuals'    separate-sections true
      zstyle ':completion:*:manuals.*'  insert-sections   true
      zstyle ':completion:*:man:*'      menu yes select
      zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' ''' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

      # Better URL pasting
      autoload -U url-quote-magic bracketed-paste-magic
      zle -N self-insert url-quote-magic
      zle -N bracketed-paste bracketed-paste-magic
    '';
  };
}

