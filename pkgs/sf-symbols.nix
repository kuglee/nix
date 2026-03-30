{ mkMacApp }:

let
  version = "7";
in
mkMacApp {
  pname = "sf-symbols";
  inherit version;
  url = "https://devimages-cdn.apple.com/design/resources/download/SF-Symbols-${version}.dmg";
  hash = "sha256-wvIneQKZylFCIDac6DBXB3RX+8wI8OCjJi4zvKRAigI=";
}
