final: prev:

let
  inherit (final) callPackage;
in
{
  dsda-doom = callPackage ./dsda-doom/default.nix {};
  woof-doom = callPackage ./woof-doom/default.nix {};
  neural-amp-modeler-ui = callPackage ./neural-amp-modeler-ui/default.nix {};
}
