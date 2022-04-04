{ pkgs ? import <nixpkgs> { } }:

with pkgs;

lib.makeScope newScope (self: with self; {
  gradle = callPackage ./gradle.nix { jdk = adoptopenjdk-hotspot-bin-11; };

  updateLocks = callPackage ./update-locks.nix {
    inherit (haskellPackages) xml-to-json;
  };

  buildMavenRepo = callPackage ./maven-repo.nix { };

  mavenRepo = buildMavenRepo {
    name = "nix-maven-repo";
    # TODO Figure out these repos.
    repos = [
      "https://cache-redirector.jetbrains.com/intellij-dependencies"
      "https://plugins.gradle.org/m2"
      "https://repo1.maven.org/maven2"
      "https://jcenter.bintray.com/"
      "https://dl.bintray.com/jetbrains/markdown"

      "https://cache-redirector.jetbrains.com/intellij-dependencies"
      "https://cache-redirector.jetbrains.com/plugins.gradle.org"
      "https://cache-redirector.jetbrains.com/repo1.maven.org/maven2"

      "https://repository.jboss.org/nexus/content/repositories/public/"
      "https://www.jitpack.io"
      "https://cache-redirector.jetbrains.com/www.jetbrains.com/intellij-repository/releases"
    ];
    deps = builtins.fromJSON (builtins.readFile ./deps.json);
  };

  builtWithGradle = callPackage ./build.nix { };
})
