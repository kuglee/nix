{ mkMacApp }:

let
  version = "4.5.1";
in
mkMacApp {
  pname = "forklift";
  inherit version;
  url = "https://download.binarynights.com/ForkLift/ForkLift${version}.zip";
  hash = "sha256-wrvTkM91cZVtKRGDUvRAZHdNKB5WxJBAtGhiXELItck=";
}
