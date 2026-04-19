{ mkMacApp }:

let
  version = "1-0-5";
in
mkMacApp {
  pname = "kinesis-smart-set-app";
  inherit version;
  url = "https://kinesis-ergo.com/download/advantage-360-smartset-app-macos-v${version}/?wpdmdl=37237";
  hash = "sha256-4Wq+MdGcaSVRQJHXdJAVagFWbqzLTUY+qIZKEDtIlHQ=";
  type = "zip";
}
