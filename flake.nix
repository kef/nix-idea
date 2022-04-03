{
  description = "Nix language plugin for Intellij IDEA";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        default = import ./default.nix { inherit pkgs; };
        packages.nix-idea = default.builtWithGradle;
        packages.updateLocks = default.updateLocks;
        defaultPackage = packages.nix-idea;

        #apps.nix-idea = {
          #type = "app";
          #program = "${packages.nix-idea}/bin/gradle2nix";
        #};
        #defaultApp = apps.nix-idea;
      }
    );
}
