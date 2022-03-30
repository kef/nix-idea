{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  buildGradle = callPackage ./gradle-env.nix {};
in
  buildGradle {
    envSpec = ./gradle-env.json;
    src = ./.;
  }
