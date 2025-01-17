final: prev:

let
  # callPackage = lib.callPackageWith (pkgs // customPkgs);
  inherit (final) callPackage;
  customPkgs = {
    dsda-doom = callPackage ./dsda-doom/default.nix {};
    woof-doom = callPackage ./woof-doom/default.nix {};
  };
in
{
  dsda-doom = callPackage ./dsda-doom/default.nix {};
  woof-doom = callPackage ./woof-doom/default.nix {};
}
