{ mkMacApp }:

let
  version = "1.12.4.0";
in
mkMacApp {
  pname = "display-pilot";
  inherit version;
  url = "https://drive.usercontent.google.com/download?id=1910YHEJCTHMUxhMMGwCDXufMtcZcIqPU&export=download&confirm=t&uuid=c7c6ea0b-77b4-4ea5-96d3-34c0f8ad5a5a";
  hash = "sha256-7qlQAh19+WRgb7HxbkxkiFhBPetNQcjby9cIGA8ZLe0=";
  type = "zip";
}
