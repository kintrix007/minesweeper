let
  url = "https://github.com/NixOS/nixpkgs/archive/e49c28b3baa3a93bdadb8966dd128f9985ea0a09.tar.gz";
in
{ pkgs ? import (fetchTarball url) { }, cliOnly ? false }:

pkgs.stdenv.mkDerivation {
  pname = "minesweeper";
  version = "1.0.0";

  nativeBuildInputs = with pkgs; [
    pkg-config
    meson
    ninja
    cmake
    gcc
    vala
    vala-language-server
  ];

  buildInputs = with pkgs; [
    gtk4
  ];

  src = ./.;

  # ! The following would NOT work. This would overwrite the default meson
  # ! install behaviour, so it would only copy the .desktop file
  # installPhase = ''
  #   mkdir -p $out/share/applications
  #   cp $src/dist/me.kintrix.Minesweeper.desktop $out/share/applications
  #   substituteInPlace $out/share/applications/me.kintrix.Minesweeper.desktop \
  #     --replace "Exec=minesweeper" "Exec=$out/bin/minesweeper"
  # '';

  mesonFlags = pkgs.lib.optional cliOnly "-Dcli_only=true";

  inherit cliOnly;

  postInstall = ''
    # If not CLI only
    if [[ -z $cliOnly ]]; then
      mkdir -p $out/share/applications
      cp $src/dist/me.kintrix.Minesweeper.desktop $out/share/applications
      substituteInPlace $out/share/applications/me.kintrix.Minesweeper.desktop \
        --replace "Exec=minesweeper" "Exec=$out/bin/minesweeper"

      ln -s ${pkgs.papirus-icon-theme}/share/icons $out/share/icons
    fi
  '';
}
