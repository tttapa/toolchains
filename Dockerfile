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

# Build the toolchain
COPY defconfig .
RUN ct-ng defconfig
RUN ct-ng build || { cat build.log && false; } && rm -rf .build

# Build container --------------------------------------------------------------

FROM ubuntu:jammy

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
RUN mkdir -p ~/.local/bin && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-addr2line ~/.local/bin/addr2line && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-ar ~/.local/bin/ar && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-as ~/.local/bin/as && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-c++ ~/.local/bin/c++ && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-c++filt ~/.local/bin/c++filt && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-cc ~/.local/bin/cc && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-cpp ~/.local/bin/cpp && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-elfedit ~/.local/bin/elfedit && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-g++ ~/.local/bin/g++ && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gcc ~/.local/bin/gcc && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gcc-12.1.0 ~/.local/bin/gcc-12.1.0 && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gcc-ar ~/.local/bin/gcc-ar && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gcc-nm ~/.local/bin/gcc-nm && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gcc-ranlib ~/.local/bin/gcc-ranlib && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gcov ~/.local/bin/gcov && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gcov-dump ~/.local/bin/gcov-dump && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gcov-tool ~/.local/bin/gcov-tool && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gdb ~/.local/bin/gdb && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gdb-add-index ~/.local/bin/gdb-add-index && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gfortran ~/.local/bin/gfortran && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-gprof ~/.local/bin/gprof && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-ld ~/.local/bin/ld && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-ld.bfd ~/.local/bin/ld.bfd && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-ldd ~/.local/bin/ldd && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-lto-dump ~/.local/bin/lto-dump && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-nm ~/.local/bin/nm && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-objcopy ~/.local/bin/objcopy && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-objdump ~/.local/bin/objdump && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-populate ~/.local/bin/populate && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-ranlib ~/.local/bin/ranlib && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-readelf ~/.local/bin/readelf && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-size ~/.local/bin/size && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-strings ~/.local/bin/strings && \
    ln -s ../../opt/x86_64-centos7-linux-gnu/bin/x86_64-centos7-linux-gnu-strip ~/.local/bin/strip && \
    :
ENV PATH=/home/develop/.local/bin:$PATH
RUN gcc --version
