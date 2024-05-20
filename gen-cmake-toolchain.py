import sys
from platform_config import (
    PlatformConfig,
    arch_flags,
    cmake_system_name,
    cmake_system_processor,
    cpack_debian_architecture,
    multiarch_lib_dir,
)

toolchain_contents = """\
# For more information, see 
# https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html,
# https://cmake.org/cmake/help/book/mastering-cmake/chapter/Cross%20Compiling%20With%20CMake.html, and
# https://tttapa.github.io/Pages/Raspberry-Pi/C++-Development-RPiOS/index.html.

include(CMakeDependentOption)

# System information
set(CMAKE_SYSTEM_NAME "{CMAKE_SYSTEM_NAME}")
set(CMAKE_SYSTEM_PROCESSOR "{CMAKE_SYSTEM_PROCESSOR}")
set(CROSS_GNU_TRIPLE "{CROSS_GNU_TRIPLE}"
    CACHE STRING "The GNU triple of the toolchain to use")
set(CMAKE_LIBRARY_ARCHITECTURE "{CMAKE_LIBRARY_ARCHITECTURE}")

# Compiler flags
set(CMAKE_C_FLAGS_INIT       "{ARCH_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT     "{ARCH_FLAGS}")
set(CMAKE_Fortran_FLAGS_INIT "{ARCH_FLAGS}")

# Search path configuration
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
# set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Packaging
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "{CPACK_DEBIAN_PACKAGE_ARCHITECTURE}")

# Toolchain and sysroot
set(TOOLCHAIN_DIR "${{CMAKE_CURRENT_LIST_DIR}}/${{CROSS_GNU_TRIPLE}}")
# set(CMAKE_SYSROOT "${{TOOLCHAIN_DIR}}/${{CROSS_GNU_TRIPLE}}/sysroot")

# Compiler binaries
set(CMAKE_C_COMPILER "${{TOOLCHAIN_DIR}}/bin/${{CROSS_GNU_TRIPLE}}-gcc"
    CACHE FILEPATH "C compiler")
set(CMAKE_CXX_COMPILER "${{TOOLCHAIN_DIR}}/bin/${{CROSS_GNU_TRIPLE}}-g++"
    CACHE FILEPATH "C++ compiler")
set(CMAKE_Fortran_COMPILER "${{TOOLCHAIN_DIR}}/bin/${{CROSS_GNU_TRIPLE}}-gfortran"
    CACHE FILEPATH "Fortran compiler")
"""


def get_cmake_toolchain_file(cfg: PlatformConfig):
    subs = {
        "CMAKE_SYSTEM_PROCESSOR": cmake_system_processor(cfg),
        "CMAKE_SYSTEM_NAME": cmake_system_name(cfg),
        "CROSS_GNU_TRIPLE": str(cfg),
        "CMAKE_LIBRARY_ARCHITECTURE": multiarch_lib_dir(cfg),
        "ARCH_FLAGS": arch_flags(cfg),
        "CPACK_DEBIAN_PACKAGE_ARCHITECTURE": cpack_debian_architecture(cfg),
    }
    return toolchain_contents.format(**subs)


if __name__ == "__main__":
    triple = sys.argv[1]
    outfile = sys.argv[2]
    cfg = PlatformConfig.from_string(triple)
    with open(outfile, "w") as f:
        f.write(get_cmake_toolchain_file(cfg))
