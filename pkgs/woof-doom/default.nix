{ cmake
, fetchFromGitHub
, fluidsynth
, lib
, libsndfile
, libxmp
, openal
, python3
, SDL2
, SDL2_net
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "woof-doom";
  version = "14.3.0";

  src = fetchFromGitHub {
    owner = "fabiangreffrath";
    repo = "woof";
    rev = "woof_${version}";
    sha256 = "sha256-3O4bweimpicnK6Wyjr5TK9YfwX9hye2l+6X2bCjVCXw=";
  };

  buildInputs = [
    fluidsynth
    libsndfile
    libxmp
    openal
    SDL2
    SDL2_net
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  meta = with lib; {
    homepage = "https://github.com/fabiangreffrath/woof";
    description = "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports.";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
