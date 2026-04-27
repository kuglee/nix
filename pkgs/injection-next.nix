{ mkMacApp }:

let
  version = "1.6.0";
in
mkMacApp {
  pname = "injection-next";
  inherit version;
  url = "https://github.com/johnno1962/InjectionNext/releases/download/${version}/InjectionNext.zip";
  hash = "sha256-6LDKGzzp+M/zOr91QoxkQmvVSvMmGNmUDQGsW7CqbCM=";
}
