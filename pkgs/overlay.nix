final: prev:

let
  inherit (final) callPackage;
in
{
  neural-amp-modeler-ui = callPackage ./neural-amp-modeler-ui/default.nix {};
}
