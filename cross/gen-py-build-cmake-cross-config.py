import sys
from platform_config import (
    PlatformConfig,
    python_arch,
)

cross_config_contents = """\
# For more information, see
# https://tttapa.github.io/py-build-cmake/Cross-compilation.html

arch = '{arch}'
toolchain_file = '{triple}.toolchain.cmake'
"""


def get_py_build_cmake_cross_config(cfg: PlatformConfig):
    subs = {
        "arch": python_arch(cfg),
        "triple": str(cfg),
    }
    return cross_config_contents.format(**subs)


if __name__ == "__main__":
    triple = sys.argv[1]
    outfile = sys.argv[2]
    cfg = PlatformConfig.from_string(triple)
    with open(outfile, "w") as f:
        f.write(get_py_build_cmake_cross_config(cfg))
