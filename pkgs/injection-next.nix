{ mkMacApp }:

let
  version = "2.0.0RC6";
in
mkMacApp {
  pname = "injection-next";
  inherit version;
  url = "https://github.com/johnno1962/InjectionNext/releases/download/${version}/InjectionNext.zip";
  hash = "sha256-wh4zdPA6b4PJ1GQ5k70dqw0vq1M5Nr+KM8+/lM4ilTo=";
}
