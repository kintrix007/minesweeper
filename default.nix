{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/1b7a6a6e57661d7d4e0775658930059b77ce94a4.tar.gz") { } }:

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
    papirus-icon-theme
  ];

  src = ./.;

  buildPhase = ''
    cd $src
    meson setup $out/builddir
    meson compile -C $out/builddir
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/share/applications
    mv $out/builddir/minesweeper $out/bin/
    cp $src/dist/me.kintrix.Minesweeper.desktop $out/share/applications
    # substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
    #   --replace "Exec=godot" "Exec=$out/bin/godot"
    substituteInPlace $out/share/applications/me.kintrix.Minesweeper.desktop \
      --replace "Exec=minesweeper" "Exec=$out/bin/minesweeper"
  '';
}
