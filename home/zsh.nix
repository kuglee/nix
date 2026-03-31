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
      reloadprefs = "killall -u $(whoami) cfprefsd";

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
    };

    # Init commands (additional configuration)
    initContent = ''
      # Completion styles
      zstyle ':completion:*:manuals'    separate-sections true
      zstyle ':completion:*:manuals.*'  insert-sections   true
      zstyle ':completion:*:man:*'      menu yes select
      zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' ''' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

      # Tab completion with dots
      expand-or-complete-with-dots() {
        echo -n "\e[31m......\e[0m"
        zle expand-or-complete
        zle redisplay
      }
      zle -N expand-or-complete-with-dots
      bindkey "^I" expand-or-complete-with-dots

      # Better URL pasting
      autoload -U url-quote-magic bracketed-paste-magic
      zle -N self-insert url-quote-magic
      zle -N bracketed-paste bracketed-paste-magic
    '';
  };
}

