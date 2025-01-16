{ fetchFromGitHub
, alsa-lib
, cmake
, dumb
, lib
, libGLU
, libmad
, libzip
, portmidi
, SDL2
, SDL2_image
, SDL2_mixer
, soundfont-fluid
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "dsda-doom";
  version = "0.27.5";

  src = fetchFromGitHub {
    owner = "kraflab";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-+rvRj6RbJ/RaKmlDZdB2oBm/U6SuHNxye8TdpEOZwQw=";
  };

  sourceRoot = "${src.name}/prboom2";

  buildInputs = [
    alsa-lib
    dumb
    libGLU
    libmad
    libzip
    portmidi
    SDL2
    SDL2_image
    SDL2_mixer
  ];

  nativeBuildInputs = [
    cmake
  ];

  # Fixes impure path to soundfont
  prePatch = ''
    substituteInPlace src/m_misc.c --replace \
      "/usr/share/sounds/sf3/default-GM.sf3" \
      "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2"
  '';

  meta = with lib; {
    homepage = "https://github.com/kraflab/dsda-doom";
    description = "This is a successor of prboom+ with extra tooling for demo recording and playback, with a focus on speedrunning and quality of life.";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
