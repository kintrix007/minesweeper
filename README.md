# Minesweeper

### This is my little project to get into learning GTK with Vala.

![Screenshot of the game window](screenshot.png)

---

### Dependencies

This project uses system icons which may or may not exist with the same name - or at all - on your system.

- vala, gcc
- gtk4
- meson, ninja, cmake
- pkg-config

**Void Linux:**

```sh
sudo xbps-install -S gcc vala meson ninja cmake pkg-config gtk4-devel
```
For development also install the `vala-language-server` package.

**Fedora Linux:**
```sh
sudo dnf install gcc vala meson ninja-build cmake pkg-config gtk4-devel
``` 
For development also install the `vala-language-server` package.

---

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
