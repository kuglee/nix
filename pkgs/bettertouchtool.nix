{ mkMacApp }:

let
  version = "6.322-2026033009";
in
mkMacApp {
  pname = "bettertouchtool";
  inherit version;
  url = "https://folivora.ai/releases/btt${version}.zip";
  hash = "sha256-WSr337sKWUyHdxEzqqV6A5YKsn4DhoSXSYpXtehouP0=";
}
