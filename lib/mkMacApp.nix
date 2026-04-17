{ lib, stdenvNoCC, fetchurl, unzip, undmg }:

{
  pname,
  version,
  url,
  hash,
  license ? lib.licenses.unfree,
}:

let
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
    temp=$(mktemp -d)
    unzip -d $temp $src
    mkdir -p $out/Applications
    mv -f $temp/*.app $out/Applications/
    runHook postInstall
  '' else if isDmg then ''
    runHook preInstall
    mountpoint=$(mktemp -d)
    /usr/bin/hdiutil attach "$src" -mountpoint "$mountpoint" -nobrowse -quiet

    mkdir -p $out/Applications

    if [ -n "$(find "$mountpoint" -maxdepth 1 -name '*.app' 2>/dev/null)" ]; then
      cp -r "$mountpoint"/*.app $out/Applications/
    elif [ -n "$(find "$mountpoint" -maxdepth 1 -name '*.pkg' 2>/dev/null)" ]; then
      pkgpath=$(find "$mountpoint" -maxdepth 1 -name '*.pkg' | head -1)
      pkgtemp=$(mktemp -d)
      /usr/sbin/pkgutil --expand "$pkgpath" "$pkgtemp/expanded"

      find "$pkgtemp/expanded" -name Payload > "$pkgtemp/payloads.txt"
      while read payload; do
        /usr/bin/gunzip -c "$payload" | (cd "$pkgtemp" && /usr/bin/cpio -id 2>/dev/null) || true
      done < "$pkgtemp/payloads.txt"

      echo "Extracted contents of pkgtemp:"
      find "$pkgtemp" -name '*.app'

      find "$pkgtemp" -name '*.app' > "$pkgtemp/apps.txt"
      while read app; do
        cp -r "$app" "$out/Applications/"
      done < "$pkgtemp/apps.txt"
    else
      echo "No .app or .pkg found in DMG contents:"
      ls "$mountpoint"
      exit 1
    fi

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
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}

