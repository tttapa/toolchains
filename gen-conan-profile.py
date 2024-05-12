import sys
from platform_config import (
    PlatformConfig,
    conan_arch,
    arch_flags,
)

cross_config_contents = """\
[settings]
arch={arch}
build_type=Release
compiler=gcc
compiler.cppstd=gnu17
compiler.libcxx=libstdc++11
compiler.version={gcc_version}
os=Linux

[conf]
tools.cmake.cmaketoolchain:user_toolchain=["{{{{ os.path.join(profile_dir, "{triple}.toolchain.cmake") }}}}"]
tools.gnu:host_triplet={triple}
# tools.build:sysroot="{{{{ os.path.join(profile_dir, "{triple}/{triple}/sysroot") }}}}"
tools.build:cflags={arch_flags}
tools.build:cxxflags={arch_flags}
tools.build:compiler_executables={{ "c": "{{{{ os.path.join(profile_dir, "{triple}/bin/{triple}-gcc") }}}}", "cpp": "{{{{ os.path.join(profile_dir, "{triple}/bin/{triple}-g++") }}}}", "fortran": "{{{{ os.path.join(profile_dir, "{triple}/bin/{triple}-gfortran") }}}}" }}
"""


def get_py_build_cmake_cross_config(cfg: PlatformConfig, gcc_version: str):
    subs = {
        "arch": conan_arch(cfg),
        "gcc_version": gcc_version,
        "triple": str(cfg),
        "arch_flags": arch_flags(cfg).split()
    }
    return cross_config_contents.format(**subs)


if __name__ == "__main__":
    triple = sys.argv[1]
    gcc_version = sys.argv[2]
    outfile = sys.argv[3]
    cfg = PlatformConfig.from_string(triple)
    with open(outfile, "w") as f:
        f.write(get_py_build_cmake_cross_config(cfg, gcc_version))
