{ pkgs, lib, ... }:

let
  callPackage = lib.callPackageWith (pkgs // customPkgs);
  customPkgs = {
    dsda-doom = callPackage ./dsda-doom/default.nix {};
    woof-doom = callPackage ./woof-doom/default.nix {};
  };
in
  customPkgs
