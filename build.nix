{ lib
, stdenv
, jdk
, gradle
, mavenRepo
}:

stdenv.mkDerivation {
  pname = "built-with-gradle";
  version = "0.0";
  
  nativeBuildInputs = [ gradle ];
  
  JDK_HOME = "${jdk.home}";
  
  buildPhase = ''
    runHook preBuild
    gradle build \
      --offline --no-daemon --no-build-cache --info --full-stacktrace \
      --warning-mode=all --parallel --console=plain \
      -PnixMavenRepo=${mavenRepo}
    runHook postBuild
  '';
#      -DnixMavenRepo=file://${mavenRepo}

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r build/dist/* $out
    runHook postInstall
  '';
#    cp -r app/build/outputs/* $out

  dontStrip = true;
}
