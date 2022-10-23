BUILD_TRIPLE    := x86_64-unknown-linux-gnu
HOST_TRIPLE     := armv6-rpi-linux-gnueabihf
PYTHON_VERSION  := 3.10.8
PYTHON_SUFFIX   :=
BUILD_PYTHON    := python3.10

TOOLCHAIN       := x-tools-$(HOST_TRIPLE).tar.xz
TOOLCHAIN_URL   := https://github.com/tttapa/toolchains/releases/latest/download
CMAKE_DIR       := cmake
PYTHON_FULL     := Python-$(PYTHON_VERSION)$(PYTHON_SUFFIX)
PYTHON_MAJOR    := $(word 1,$(subst ., ,$(PYTHON_VERSION)))
PYTHON_MINOR    := $(word 2,$(subst ., ,$(PYTHON_VERSION)))
PYTHON_URL      := https://www.python.org/ftp/python

BASE_DIR        := $(shell pwd)
PY_STAGING_DIR  := staging/$(HOST_TRIPLE)/$(PYTHON_MAJOR).$(PYTHON_MINOR)
PY_BUILD_DIR    := build/$(HOST_TRIPLE)/$(PYTHON_VERSION)
DOWNLOAD_DIR    := download

export PATH := $(BASE_DIR)/x-tools/$(HOST_TRIPLE)/bin:$(PATH)

all: python cmake py-build-cmake

.PHONY: all python clean toolchain cmake

# Directories
$(DOWNLOAD_DIR)/.dirstamp:
	mkdir -p $(DOWNLOAD_DIR)
	touch $@

$(PY_STAGING_DIR)/.dirstamp:
	mkdir -p $(PY_STAGING_DIR)
	touch $@

$(PY_BUILD_DIR)/.dirstamp:
	mkdir -p $(PY_BUILD_DIR)
	touch $@

$(CMAKE_DIR)/.dirstamp:
	mkdir -p $(CMAKE_DIR)
	touch $@

# Toolchain
$(DOWNLOAD_DIR)/$(TOOLCHAIN): $(DOWNLOAD_DIR)/.dirstamp
	wget $(TOOLCHAIN_URL)/$(TOOLCHAIN) -O $@
	touch $@
	tar xJf $@
toolchain: $(TOOLCHAIN)

# Python
PYTHON_TGZ       := $(DOWNLOAD_DIR)/$(PYTHON_FULL).tgz
PYTHON_CONFIGURE := $(PY_BUILD_DIR)/$(PYTHON_FULL)/configure
PYTHON_MAKEFILE  := $(PY_BUILD_DIR)/$(PYTHON_FULL)/Makefile
PYTHON_BIN       := $(PY_STAGING_DIR)/usr/local/bin/python3

$(PYTHON_TGZ): $(DOWNLOAD_DIR)/.dirstamp
	wget $(PYTHON_URL)/$(PYTHON_VERSION)/$(PYTHON_FULL).tgz -O $@
	touch $@

$(PYTHON_CONFIGURE): $(PYTHON_TGZ) $(PY_BUILD_DIR)/.dirstamp
	tar xzf $< -C $(PY_BUILD_DIR)
	touch $@

$(PYTHON_MAKEFILE): $(PYTHON_CONFIGURE)
	cd $(PY_BUILD_DIR)/$(PYTHON_FULL) && \
	sed -i 's@# Debian/Ubuntu multiarch support.@return@g' setup.py && \
	CONFIG_SITE="$(BASE_DIR)/config.site" \
	./configure \
		--enable-ipv6 \
		--enable-shared \
		--disable-test-modules \
		--build="$(BUILD_TRIPLE)" \
		--host="$(HOST_TRIPLE)" \
		--prefix="/usr/local" \
		--with-build-python="$(BUILD_PYTHON)"
	sed -i 's@libainstall:\( \|	\)all@libainstall:@g' $@

$(PYTHON_BIN): $(PYTHON_MAKEFILE) $(PY_STAGING_DIR)/.dirstamp
	$(MAKE) -C $(PY_BUILD_DIR)/$(PYTHON_FULL) python python-config -j$(shell nproc)
	$(MAKE) -C $(PY_BUILD_DIR)/$(PYTHON_FULL) altbininstall inclinstall libainstall bininstall DESTDIR=$(BASE_DIR)/$(PY_STAGING_DIR)

python: $(PYTHON_BIN)

$(CMAKE_DIR)/$(HOST_TRIPLE).toolchain.cmake: $(CMAKE_DIR)/.dirstamp
	$(BUILD_PYTHON) gen-cmake-toolchain.py $(HOST_TRIPLE) $@

cmake: $(CMAKE_DIR)/$(HOST_TRIPLE).toolchain.cmake

$(CMAKE_DIR)/$(HOST_TRIPLE).py-build-cmake.cross.toml: $(CMAKE_DIR)/.dirstamp
	$(BUILD_PYTHON) gen-py-build-cmake-cross-config.py $(HOST_TRIPLE) $@

py-build-cmake: $(CMAKE_DIR)/$(HOST_TRIPLE).py-build-cmake.cross.toml

# Clean
clean:
	rm -rf $(PY_BUILD_DIR) $(PY_STAGING_DIR)
