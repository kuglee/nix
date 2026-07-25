{
  programs.rtorrent = {
    enable = true;
    extraConfig = ''
      execute.throw = sh,-c,"mkdir -p ~/.local/state/rtorrent/sessions"
      directory.default.set = ~/Movies/
      session = ~/.local/state/rtorrent/sessions
    '';
  };
}
