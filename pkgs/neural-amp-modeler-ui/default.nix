{ lib
, stdenv
, fetchFromGitHub
, cmake
, libtinfo
, pkg-config
, unzip
, cairo
, lv2
, xorg
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "neural-amp-modeler-ui";
  version = "0.1.4";
  uiVersion = "d34a9a66e9ae3a4811e9bcf6df420347e23638b0";

  withUi = false;

  src = fetchFromGitHub {
    owner = "mikeoliphant";
    repo = "neural-amp-modeler-lv2";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-5BOZOocZWWSWawXJFMAgM0NR0s0CbkzDVr6fnvZMvd0=";
  };

  uiSrc = fetchFromGitHub {
    name = "uiSrc";
    owner = "brummer10";
    repo = "neural-amp-modeler-ui";
    rev = finalAttrs.uiVersion;
    fetchSubmodules = true;
    hash = "sha256-9FyCn1Reh192ZyL6GACQ0q4x/yOOeUsCwE1kwYwtNVk=";
  };

  nativeBuildInputs = [
    cmake
    libtinfo
    pkg-config
    unzip
  ];

  buildInputs = [
    cairo.dev
    lv2.dev
    xorg.libX11.dev
  ];

  postUnpack = ''
    echo "[PostUnpack]"
    unpackFile "${uiSrc}"
    chmod -R u+w -- "$TMP/${uiSrc.name}"
  '';

  postPatch = ''
    echo "[PostPatch]"
    substituteInPlace "$TMP/${uiSrc.name}/Neural_Amp_Modeler/makefile" \
      --replace "INSTALL_DIR = /usr/lib/lv2" "INSTALL_DIR = $out/lib/lv2" \
      --replace "INSTALL_DIR = ~/.lv2"       "INSTALL_DIR = $out/lib/lv2"
  '';

  postBuild = ''
    echo "[PostBuild]"
    pushd "$TMP/${uiSrc.name}"
    make
    popd
  '';

  postInstall = ''
    echo "[PostInstall]"
    echo $out
    ls $out
    ls $out/lib/lv2
    pushd "$TMP/${uiSrc.name}"
    make install
    popd
  '';

  meta = {
    maintainers = [ lib.maintainers.viraptor ];
    description = "Neural Amp Modeler LV2 plugin implementation";
    homepage = finalAttrs.src.meta.homepage;
    license = [ lib.licenses.gpl3 ];
  };
})
