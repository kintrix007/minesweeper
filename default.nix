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
    papirus-icon-theme # Technically uses it
  ];

  src = ./.;

  buildPhase = ''
    meson setup $out/builddir $src --prefix $out
    meson compile -C $out/builddir
  '';

  installPhase = ''
    meson install -C $out/builddir

    mkdir -p $out/share/applications
    cp $src/dist/me.kintrix.Minesweeper.desktop $out/share/applications
    substituteInPlace $out/share/applications/me.kintrix.Minesweeper.desktop \
      --replace "Exec=minesweeper" "Exec=$out/bin/minesweeper"
  '';
}
