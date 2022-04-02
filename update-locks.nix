{ lib
, writeShellScriptBin
, gradle
, jq
#, xml-to-json
}:

writeShellScriptBin "update-locks" ''
  set -eu -o pipefail

  echo "gradle dependencies --write-locks"
  ${gradle}/bin/gradle dependencies --write-locks

  echo gradle --write-verification-metadata sha256 help
  ${gradle}/bin/gradle --write-verification-metadata sha256 help

#  echo "gradle buildEnvironment --write-locks"
#  ${gradle}/bin/gradle buildEnvironment --write-locks
#
#  echo gradle --write-verification-metadata sha256 help
#  ${gradle}/bin/gradle --write-verification-metadata sha256 help
''

#  ${xml-to-json}/bin/xml-to-json -sam -t components gradle/verification-metadata.xml \
#    | ${jq}/bin/jq '[
#        .[] | .component |
#        { group, name, version,
#          artifacts: [([.artifact] | flatten | .[] | {(.name): .sha256.value})] | add
#        }
#      ]' > deps.json
#
#  rm gradle/verification-metadata.xml
