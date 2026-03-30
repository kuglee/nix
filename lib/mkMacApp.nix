{ lib, stdenvNoCC, fetchurl, unzip, undmg }:

{
  pname,
  version,
  url,
  hash,
  license ? lib.licenses.unfree,
}:

let
  # Detect archive type from URL
  isDmg = lib.hasSuffix ".dmg" url;
  isZip = lib.hasSuffix ".zip" url;
  isTarGz = lib.hasSuffix ".tar.gz" url || lib.hasSuffix ".tgz" url;
  
in
stdenvNoCC.mkDerivation {
  inherit pname version;
  
  src = fetchurl {
    inherit url hash;
  };
  
  nativeBuildInputs = lib.optionals isZip [ unzip ] 
                   ++ lib.optionals isDmg [ undmg ];
  
  dontUnpack = isZip || isDmg;
  
  installPhase = if isZip then ''
    runHook preInstall
    mkdir -p $out/Applications
    unzip -d $out/Applications $src
    runHook postInstall
  '' else if isDmg then ''
    runHook preInstall
    mkdir -p $out/Applications
    mountpoint=$(mktemp -d)
    /usr/bin/hdiutil attach "$src" -mountpoint "$mountpoint" -nobrowse -quiet
    cp -r "$mountpoint"/*.app $out/Applications/
    /usr/bin/hdiutil detach "$mountpoint" -quiet
    runHook postInstall
  '' else ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications/
    runHook postInstall
  '';
  
  meta = {
    license = license;
    sourceProvigation = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}

