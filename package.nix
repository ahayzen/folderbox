# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

{ stdenv
, lib
, bash
, makeWrapper
}:
  stdenv.mkDerivation {
    pname = "folderbox";
    version = "0.2.0";
    src = lib.cleanSource ./.;
    buildInputs = [ bash ];
    buildPhase = ''
      bash ./build.sh
    '';
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp ./bin/folderbox $out/bin/folderbox
      wrapProgram $out/bin/folderbox \
        --prefix PATH : ${lib.makeBinPath [ bash ]}

      mkdir -p $out/share/templates/
      cp ./data/common/* $out/share/templates/
    '';
  }

