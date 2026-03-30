final: prev:

let
  lib = prev.lib;

  mkMacApp = final.callPackage ../lib/mkMacApp.nix {};

  # Read all files in this directory
  files = builtins.readDir ./.;

  # Keep only .nix files except default.nix
  nixFiles = lib.filterAttrs (name: type:
    type == "regular" &&
    name != "default.nix" &&
    lib.hasSuffix ".nix" name
  ) files;

  # Convert filename -> package
  packages = lib.mapAttrs' (name: _: 
    let
      pkgName = lib.removeSuffix ".nix" name;
    in
    {
      name = pkgName;
      value = final.callPackage (./. + "/${name}") {
        inherit mkMacApp;
      };
    }
  ) nixFiles;
in
packages
