import dataclasses
import warnings


@dataclasses.dataclass
class PlatformConfig:
    cpu: str
    vendor: str
    kernel: str
    system: str

    def __str__(self):
        return "-".join(dataclasses.astuple(self))

    @classmethod
    def from_string(cls, s: str):
        return cls(*s.split("-"))


def multiarch_lib_dir(cfg: PlatformConfig):
    arch = cfg.cpu
    if arch.startswith("armv"):
        arch = "arm"
    return "-".join((arch, cfg.kernel, cfg.system))


def lib_dir_32_64(cfg: PlatformConfig):
    lib = {
        "armv6": "lib",
        "armv7": "lib",
        "armv8": "lib",
        "aarch64": "lib64",
        "x86_64": "lib64",
    }
    return lib.get(cfg.cpu, "lib")


def cmake_system_processor(cfg: PlatformConfig):
    return cfg.cpu


def cmake_system_name(cfg: PlatformConfig):
    return cfg.kernel.capitalize()


def arch_flags(cfg: PlatformConfig):
    flags = {
        "rpi": {
            "armv6": "-mcpu=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard",
        },
        "rpi3": {
            "aarch64": "-mcpu=cortex-a53+crc+simd",
            "armv8": "-mcpu=cortex-a53 -mfpu=neon-fp-armv8 -mfloat-abi=hard",
        },
        "neon": {
            "armv7": "-mfpu=neon -mfloat-abi=hard",
        },
        "bionic": {
            "x86_64": "-march=haswell",
        },
        "focal": {
            "x86_64": "-march=haswell",
        },
        "centos7": {
            "x86_64": "",
        },
    }
    return flags.get(cfg.vendor, {}).get(cfg.cpu, "")


def cpack_debian_architecture(cfg: PlatformConfig):
    archs = {
        # "armv6": "armel"
        "arm": "armhf",
        "armv7": "armhf",
        "armv8": "armhf",
        "aarch64": "arm64",
        "x86_64": "amd64",
    }
    arch = archs.get(cfg.cpu, "")
    if not arch and cfg.cpu.startswith("arm") and cfg.vendor.startswith("rpi"):
        arch = "armhf"
    if not arch:
        warnings.warn("Unknown Debian architecture")
    return arch


def python_arch(cfg: PlatformConfig):
    archs = {
        "armv6": "armv6l",
        "arm": "armv7l",
        "armv7": "armv7l",
        "armv8": "armv7l",
    }
    arch = archs.get(cfg.cpu) or cfg.cpu
    os = cfg.kernel
    if os == "linux":
        os = {
            "neon": "manylinux_2_27",
            "rpi": "linux",
            "rpi3": "manylinux_2_27",
            "centos7": "manylinux_2_17",
            "bionic": "manylinux_2_27",
            "focal": "manylinux_2_31",
        }.get(cfg.vendor, os)
    return "_".join((os, arch))


def conan_arch(cfg: PlatformConfig):
    archs = {
        "armv6": "armv6",
        "armv7": "armv7hf",
        "armv8": "armv8_32",
        "aarch64": "armv8",
        "x86_64": "x86_64",
    }
    arch = archs.get(cfg.cpu, "")
    if not arch:
        warnings.warn("Unknown Conan architecture")
    return arch
