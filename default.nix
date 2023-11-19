{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/1b7a6a6e57661d7d4e0775658930059b77ce94a4.tar.gz") { } }:

pkgs.stdenv.mkDerivation {
  pname = "minesweeper";
  version = "1.0.0";

  nativeBuildInputs = with pkgs; [
    pkg-config
    meson
    ninja
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

  postInstall = ''
    mkdir -p $out/share/applications
    cp $src/dist/me.kintrix.Minesweeper.desktop $out/share/applications
    substituteInPlace $out/share/applications/me.kintrix.Minesweeper.desktop \
      --replace "Exec=minesweeper" "Exec=$out/bin/minesweeper"

    ln -s ${pkgs.papirus-icon-theme}/share/icons $out/share/icons
  '';
}
