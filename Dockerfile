# Crosstool-NG -----------------------------------------------------------------

FROM centos:7 as ct-ng

# Install dependencies to build crosstool-ng and the toolchain
RUN yum -y update && \
    yum install -y epel-release && \
    yum install -y autoconf gperf bison file flex texinfo help2man gcc-c++ \
    libtool make patch ncurses-devel python36-devel perl-Thread-Queue bzip2 \
    git wget which xz unzip rsync && \
    yum clean all

# Add a user called `develop` and add him to the sudo group
RUN useradd -m develop && echo "develop:develop" | chpasswd && \
    usermod -aG wheel develop

USER develop
WORKDIR /home/develop

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
ENV PATH=/home/develop/.local/bin:$PATH
WORKDIR /home/develop 

# Toolchain --------------------------------------------------------------------

FROM ct-ng as gcc-build

ARG HOST_TRIPLE

# Build the toolchain
COPY ${HOST_TRIPLE}.defconfig .
RUN ct-ng ${HOST_TRIPLE}.defconfig
RUN ct-ng build || { cat build.log && false; } && rm -rf .build

# Build container --------------------------------------------------------------

FROM ubuntu:jammy

ARG HOST_TRIPLE

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y \
        ninja-build cmake make bison flex \
        tar xz-utils gzip zip unzip bzip2 \
        ca-certificates wget git && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Add a user called `develop` and add him to the sudo group
RUN useradd -m develop && \
    echo "develop:develop" | chpasswd && \
    adduser develop sudo

USER develop
WORKDIR /home/develop

# Copy the toolchain
COPY --from=gcc-build /home/develop/x-tools /home/develop/opt
