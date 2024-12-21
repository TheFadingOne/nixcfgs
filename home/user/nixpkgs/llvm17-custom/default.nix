{ cmake
, fetchFromGitHub
, lib
, ninja
, python3
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "llvm-custom";
  version = "17.x";

  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "release/17.x";
    sha256 = "sha256-8MEDLLhocshmxoEBRSKlJ/GzJ8nfuzQ8qn0X/vLA+ag=";
  };

  sourceRoot = "${src.name}/llvm";

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  cmakeBuildType = "Release";
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_BINDIR=${placeholder "out"}/bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=${placeholder "dev"}/include"
    "-DCMAKE_INSTALL_LIBDIR=${placeholder "lib"}/lib"
    "-DCMAKE_INSTALL_LIBEXECDIR=${placeholder "lib"}/libexec"
    "-DLLVM_ENABLE_PROJECTS=lld;clang"
    "-DLLVM_ENABLE_LIBXML2=OFF"
    "-DLLVM_ENABLE_TERMINFO=OFF"
    "-DLLVM_ENABLE_LIBEDIT=OFF"
    "-DLLVM_ENABLE_ASSERTIONS=ON"
    "-DLLVM_PARALLEL_LINK_JOBS=1"
  ];

  meta = with lib; {
    homepage = "https://github.com/llvm/llvm-project";
    description = "The LLVM Project is a collection of modular and reusable compiler and toolchain technologies. ";
    license = licenses.asl20-llvm;
    platforms = platforms.linux;
  };
}
