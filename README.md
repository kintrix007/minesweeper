# Minesweeper

### This is my little project to get into learning GTK with Vala.

### Dependencies

This project uses system icons which may or may not exist with the same name - or at all - on your system.

- valac
- gtk4
- meson
- ninja

### Build instructions

1. Copy this repo
```sh
$ git clone https://github.com/kintrix007/minesweeper.git
```
2. Set up build directory
```sh
$ meson setup build
```
3. Compile the code
```sh
$ meson compile -C build/
```
4. You are done. The executable is located at `build/minesweeper`.
