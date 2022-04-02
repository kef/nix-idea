{ gradleGen, callPackage }:

# TODO Determine how this was derived from this project using gradle2nix.
let
  xxx = gradleGen {
    version = "6.6";
    nativeVersion = "0.22-milestone-4";
    sha256 = "e6f83508f0970452f56197f610d13c5f593baaf43c0e3c6a571e5967be754025";
  };
in
  callPackage xxx { }
