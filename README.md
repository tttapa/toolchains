# Toolchains

Modern GCC 13.2 toolchains that are compatible with a wide range of Linux
distributions (CentOS 7, Debian 10 Buster, Ubuntu 18.04 Bionic, Rocky Linux 8,
all the way up to the latest versions of these distributions).

- **Languages**: C, C++, Fortran
- **Architectures**: x86-64, ARM64, ARMv8, ARMv7, ARMv6
- **Glibc**: 2.27 and later (2.17 for `x86_64-centos7-linux-gnu`)
- **Linux**: 4.15 and later (3.10 for `x86_64-centos7-linux-gnu`)

The toolchains themselves can be used on any x86-64 system running CentOS 7 or
later.

## Purpose

These toolchains are meant to cross-compile packages for binary distribution,
ensuring that they are compatible with a wide range of (older) Linux
distributions. The glibc and Linux versions of the toolchains are crucial here,
so you cannot use the default compilers in your system's package manager.

## Download

The ready-to-use toolchain tarballs can be downloaded from the [Releases page](https://github.com/tttapa/toolchains/releases).

Direct links: 
- [**x86_64-centos7-linux-gnu**](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-centos7-linux-gnu.tar.xz) (64-bit x86, CentOS 7 and later)
- [**x86_64-bionic-linux-gnu**](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-x86_64-bionic-linux-gnu.tar.xz) (64-bit x86, Ubuntu 18.04 Bionic, Debian 10 Buster, Rocky 8 and later, Intel Haswell and later)
- [**aarch64-rpi3-linux-gnu**](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-aarch64-rpi3-linux-gnu.tar.xz) (64-bit, RPi 2B rev. 1.2, RPi 3B/3B+, CM 3, RPi 4B/400, CM 4, RPi Zero 2 W)
- [**armv8-rpi3-linux-gnueabihf**](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv8-rpi3-linux-gnueabihf.tar.xz) (32-bit, RPi 2B rev. 1.2, RPi 3B/3B+, CM 3, RPi 4B/400, CM 4, RPi Zero 2 W)
- [**armv7-neon-linux-gnueabihf**](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv7-neon-linux-gnueabihf.tar.xz) (32-bit, generic ARM with NEON enabled)
- [**armv6-rpi-linux-gnueabihf**](https://github.com/tttapa/toolchains/releases/latest/download/x-tools-armv6-rpi-linux-gnueabihf.tar.xz) (32-bit, RPi A/B/A+/B+, CM 1, RPi Zero/Zero W)

## Usage

CMake toolchain files and Conan profiles for the toolchains are included.
