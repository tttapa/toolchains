import dataclasses
import os
from subprocess import run
from platform_config import PlatformConfig

this_dir = os.path.dirname(__file__)


@dataclasses.dataclass
class PythonVersion:
    major: int
    minor: int
    patch: int
    suffix: str = ""


platforms = [
    PlatformConfig("x86_64", "centos7", "linux", "gnu"),
    PlatformConfig("aarch64", "rpi3", "linux", "gnu"),
    PlatformConfig("armv8", "rpi3", "linux", "gnueabihf"),
    PlatformConfig("armv6", "rpi", "linux", "gnueabihf"),
]

py_versions = [
    PythonVersion(3, 7, 15),
    PythonVersion(3, 8, 15),
    PythonVersion(3, 9, 15),
    PythonVersion(3, 10, 8),
    PythonVersion(3, 11, 0, "rc2"),
]

for py in py_versions:
    for platform in platforms:
        cmd = [
            "make",
            "-C",
            this_dir,
            # "python",
            # "cmake",
            # "py-build-cmake",
            f"HOST_TRIPLE={platform}",
            f"PYTHON_VERSION={py.major}.{py.minor}.{py.patch}",
            f"PYTHON_SUFFIX={py.suffix}",
            f"BUILD_PYTHON=python{py.major}.{py.minor}",
        ]
        print(cmd)
        run(cmd, check=True)
