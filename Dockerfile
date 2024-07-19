# Python config ----------------------------------------------------------------

FROM python:3 AS config

ARG HOST_TRIPLE
ARG GCC_VERSION

COPY *.py .
RUN mkdir /config-${HOST_TRIPLE}
RUN python3 gen-cmake-toolchain.py ${HOST_TRIPLE} /config-${HOST_TRIPLE}/${HOST_TRIPLE}.toolchain.cmake
RUN python3 gen-conan-profile.py ${HOST_TRIPLE} ${GCC_VERSION} /config-${HOST_TRIPLE}/${HOST_TRIPLE}.profile.conan

# Crosstool-NG -----------------------------------------------------------------

FROM rockylinux:8 AS ct-ng

# Install dependencies to build crosstool-ng and the toolchain
RUN dnf -y update ca-certificates && \
    dnf -y update && \
    dnf install -y epel-release && \
    dnf install -y dnf-plugins-core && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y autoconf bison file flex gcc-c++ git libtool make \
    ncurses-devel patch perl-Thread-Queue python3-devel \
    gperf texinfo help2man \
    rsync unzip wget which xz bzip2 && \
    dnf clean all

# Add a user called `develop` and add him to the sudo group
RUN useradd -m develop && echo "develop:develop" | chpasswd && \
    usermod -aG wheel develop

USER develop
WORKDIR /home/develop

# Install autoconf
RUN wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz -O- | tar xz && \
    cd autoconf-2.72 && \
    ./configure --prefix=/home/develop/.local && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf autoconf-2.72
ENV PATH=/home/develop/.local/bin:$PATH

# Build crosstool-ng
RUN git clone -b master --single-branch --depth 1 \
        https://github.com/crosstool-ng/crosstool-ng.git
WORKDIR /home/develop/crosstool-ng
RUN git show --summary && \
    ./bootstrap && \
    mkdir build && cd build && \
    ../configure --prefix=/home/develop/.local && \
    make -j$(($(nproc) * 2)) && \
    make install &&  \
    cd .. && rm -rf build
WORKDIR /home/develop

# Patches
# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=280707&p=1700861#p1700861
RUN wget https://ftp.debian.org/debian/pool/main/b/binutils/binutils_2.41-6.debian.tar.xz -O- | \
    tar xJ debian/patches/129_multiarch_libpath.patch && \
    mkdir -p patches/binutils/2.41 && \
    mv debian/patches/129_multiarch_libpath.patch patches/binutils/2.41 && \
    rm -rf debian

# Toolchain --------------------------------------------------------------------

FROM ct-ng AS gcc-build

ARG HOST_TRIPLE
ARG GCC_VERSION

# Build the toolchain
COPY --chown=develop:develop ${HOST_TRIPLE}.defconfig .
COPY --chown=develop:develop ${HOST_TRIPLE}.env .
RUN [ -n "${GCC_VERSION}" ] && { echo "CT_GCC_V_${GCC_VERSION}=y" >> ${HOST_TRIPLE}.defconfig; }
RUN cp ${HOST_TRIPLE}.defconfig defconfig && ct-ng defconfig
RUN . ./${HOST_TRIPLE}.env && \
    ct-ng build || { cat build.log && false; } && rm -rf .build
COPY --chown=develop:develop --from=config /config-${HOST_TRIPLE}/* /home/develop/x-tools

# Build container --------------------------------------------------------------

FROM ubuntu:jammy

ARG HOST_TRIPLE

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y \
        ninja-build cmake make bison flex \
        tar xz-utils gzip zip unzip bzip2 zstd \
        ca-certificates wget git sudo && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Add a user called `develop` and add him to the sudo group
RUN useradd -m develop && \
    echo "develop:develop" | chpasswd && \
    adduser develop sudo

USER develop
WORKDIR /home/develop

ENV TOOLCHAIN_PATH=/home/develop/opt/x-tools/${HOST_TRIPLE}
ENV PATH=${TOOLCHAIN_PATH}/bin:$PATH

# Copy the toolchain
COPY --chown=develop:develop --from=gcc-build /home/develop/x-tools /home/develop/opt/x-tools
