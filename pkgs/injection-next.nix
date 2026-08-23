{ mkMacApp }:

let
  version = "2.0.1";
in
mkMacApp {
  pname = "injection-next";
  inherit version;
  url = "https://github.com/johnno1962/InjectionNext/releases/download/${version}/InjectionNext.zip";
  hash = "sha256-c5DbAKgr6/b6K4KPKOQNKbEtVR5MdJoVd5znnq4dlzc=";
}
