# For more information, see 
# https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html and
# https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development-RPiOS/index.html.

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CROSS_GNU_TRIPLE "aarch64-rpi3-linux-gnu"
    CACHE STRING "The GNU triple of the toolchain to use")
set(CMAKE_LIBRARY_ARCHITECTURE aarch64-linux-gnu)

set(TOOLCHAIN_DIR "${CMAKE_CURRENT_LIST_DIR}/../x-tools/${CROSS_GNU_TRIPLE}")
set(CMAKE_C_COMPILER "${TOOLCHAIN_DIR}/bin/${CROSS_GNU_TRIPLE}-gcc"
    CACHE FILEPATH "C compiler")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_DIR}/bin/${CROSS_GNU_TRIPLE}-g++"
    CACHE FILEPATH "C++ compiler")
set(CMAKE_Fortran_COMPILER "${TOOLCHAIN_DIR}/bin/${CROSS_GNU_TRIPLE}-gfortran"
    CACHE FILEPATH "Fortran compiler")

set(ARCH_FLAGS "-mcpu=cortex-a53+crc+simd")
set(CMAKE_C_FLAGS_INIT "${CMAKE_C_FLAGS} ${ARCH_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS} ${ARCH_FLAGS}")
set(CMAKE_Fortran_FLAGS_INIT "${CMAKE_Fortran_FLAGS} ${ARCH_FLAGS}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE arm64)

find_package(Python3 REQUIRED COMPONENTS Interpreter)
set(Python3_VERSION_MAJ_MIN "${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}")
set(ARCH_STAGING_DIR "${CMAKE_CURRENT_LIST_DIR}/../staging/${CROSS_GNU_TRIPLE}")
set(PYTHON_STAGING_DIR "${ARCH_STAGING_DIR}/${Python3_VERSION_MAJ_MIN}")
set(Python3_LIBRARY "${PYTHON_STAGING_DIR}/usr/local/lib/libpython${Python3_VERSION_MAJ_MIN}.so")
set(Python3_INCLUDE_DIR "${PYTHON_STAGING_DIR}/usr/local/include/python${Python3_VERSION_MAJ_MIN}")
list(APPEND CMAKE_FIND_ROOT_PATH "${PYTHON_STAGING_DIR}")
