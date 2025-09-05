# Toolchains

Modern GCC 15.2 toolchains that are compatible with a wide range of Linux
distributions.

- **Languages**: C, C++, Fortran
- **Architectures**: x86-64, ARM64, ARMv8, ARMv7, ARMv6
- **Glibc**: 2.27 and later (2.17 for `x86_64-centos7-linux-gnu`, 2.31 for `x86_64-focal-linux-gnu`)
- **Linux**: 4.15 and later (3.10 for `x86_64-centos7-linux-gnu`, 5.4 for `x86_64-focal-linux-gnu`)
- **Distributions**: Debian 10 Buster, Ubuntu 18.04 Bionic, Rocky 8 and later

The toolchains themselves can be used on any x86-64 system running Debian 10
Buster, Ubuntu 18.04 Bionic, Rocky 8 and later.

## Purpose

These toolchains are meant to cross-compile packages for binary distribution,
ensuring that they are compatible with a wide range of (older) Linux
distributions. The glibc and Linux versions of the toolchains are crucial here,
so you cannot use the default compilers in your system's package manager.

## Download

The ready-to-use toolchain tarballs can be downloaded from the [Releases page](https://github.com/tttapa/toolchains/releases).  
Direct links are available in the table below:

| Target triplet | GCC 15.2 | GCC 14.3 | GCC 13.4 | GCC 12.5 | Supported hardware | Supported distributions |
|---------------:|:--------:|:--------:|:--------:|:--------:|:-------------------|:------------------------|
| `x86_64-focal-linux-gnu` | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-focal-linux-gnu-gcc15.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-focal-linux-gnu-gcc14.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-focal-linux-gnu-gcc13.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-focal-linux-gnu-gcc12.tar.xz) | 64-bit x86 Intel/AMD | Ubuntu 20.04 Focal, Debian 11 Bullseye, Rocky 9 and later |
| `x86_64-bionic-linux-gnu` | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-bionic-linux-gnu-gcc15.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-bionic-linux-gnu-gcc14.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-bionic-linux-gnu-gcc13.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-bionic-linux-gnu-gcc12.tar.xz) | 64-bit x86 Intel/AMD | Ubuntu 18.04 Bionic, Debian 10 Buster, Rocky 8 and later |
| `x86_64-centos7-linux-gnu` | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-centos7-linux-gnu-gcc15.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-centos7-linux-gnu-gcc14.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-centos7-linux-gnu-gcc13.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-centos7-linux-gnu-gcc12.tar.xz) | 64-bit x86 Intel/AMD | CentOS 7 and later |
| `aarch64-rpi3-linux-gnu` | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-gcc15.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-gcc14.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-gcc13.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu-gcc12.tar.xz) | 64-bit ARMv8 (RPi 2B rev. 1.2, RPi 3B/3B+, CM 3, RPi 4B/400, CM 4, RPi Zero 2 W, RPi 5) | Ubuntu 18.04 Bionic, Debian 10 Buster, Rocky 8 and later |
| `armv8-rpi3-linux-gnueabihf` | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv8-rpi3-linux-gnueabihf-gcc15.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv8-rpi3-linux-gnueabihf-gcc14.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv8-rpi3-linux-gnueabihf-gcc13.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv8-rpi3-linux-gnueabihf-gcc12.tar.xz) | 32-bit ARMv8 (RPi 2B rev. 1.2, RPi 3B/3B+, CM 3, RPi 4B/400, CM 4, RPi Zero 2 W, RPi 5) | Ubuntu 18.04 Bionic, Debian 10 Buster and later |
| `armv7-neon-linux-gnueabihf` | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv7-neon-linux-gnueabihf-gcc15.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv7-neon-linux-gnueabihf-gcc14.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv7-neon-linux-gnueabihf-gcc13.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv7-neon-linux-gnueabihf-gcc12.tar.xz) | 32-bit ARMv7 (NEON enabled) | Ubuntu 18.04 Bionic, Debian 10 Buster and later |
| `armv6-rpi-linux-gnueabihf` | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf-gcc15.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf-gcc14.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf-gcc13.tar.xz) | [⬇️](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf-gcc12.tar.xz) | 32-bit ARMv6 (RPi A/B/A+/B+, CM 1, RPi Zero/Zero W) | Raspberry Pi OS 10 Buster and later |

```sh
mkdir -p ~/opt
url=https://github.com/tttapa/toolchains/releases/latest/download
wget $url/x-tools-x86_64-bionic-linux-gnu-gcc15.tar.xz -O- | tar xJ -C ~/opt
```

## Usage

CMake toolchain files and Conan profiles for the toolchains are included:

```sh
cmake -B build -S . --toolchain ~/opt/x-tools/x86_64-bionic-linux-gnu.toolchain.cmake
```
```sh
conan install . -pr:h ~/opt/x-tools/x86_64-bionic-linux-gnu.profile.conan
```
