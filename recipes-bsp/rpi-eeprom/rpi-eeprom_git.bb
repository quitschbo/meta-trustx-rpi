SUMMARY = "Installation scripts and binaries for the Raspberry Pi 4 EEPROM"
DESCRIPTION = "This repository contains the rpi4 bootloader and scripts \
for updating it in the spi eeprom"
LICENSE = "BSD-3-Clause & Broadcom-RPi & MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=449418bd5e2b674b51a36c78f3f85a01"

SRC_URI = " \
    git://github.com/raspberrypi/rpi-eeprom.git;protocol=https;branch=master \
"

SRCREV = "b67b21ddda8b6468090fcdc5034bb075344a8903"
PV = "v2025.01.22-2712"

S = "${WORKDIR}/git"

RDEPENDS:${PN} += " \
    coreutils \
    python3 \
    python3-pycryptodomex \
    openssl \
    vim \
"

RDEPENDS:${PN}:append:class-target = " pciutils"

inherit python3native

do_install() {
    install -d ${D}${bindir}

    # install executables
    install -m 0755 ${S}/tools/vl805 ${D}${bindir}
    install -m 0755 ${S}/rpi-eeprom-update ${D}${bindir}
    install -m 0755 ${S}/rpi-eeprom-config ${D}${bindir}
    install -m 0755 ${S}/rpi-eeprom-digest ${D}${bindir}
    install -m 0755 ${S}/tools/rpi-sign-bootcode ${D}${bindir}

    # copy firmware files
    install -d ${D}${base_libdir}/firmware/raspberrypi/bootloader-2711/default
    install -d ${D}${base_libdir}/firmware/raspberrypi/bootloader-2711/latest
    install -d ${D}${base_libdir}/firmware/raspberrypi/bootloader-2712/default
    install -d ${D}${base_libdir}/firmware/raspberrypi/bootloader-2712/latest

    install -m 644 ${S}/firmware-2711/default/* ${D}${base_libdir}/firmware/raspberrypi/bootloader-2711/default
    install -m 644 ${S}/firmware-2711/latest/* ${D}${base_libdir}/firmware/raspberrypi/bootloader-2711/latest
    install -m 644 ${S}/firmware-2712/default/* ${D}${base_libdir}/firmware/raspberrypi/bootloader-2712/default
    install -m 644 ${S}/firmware-2712/latest/* ${D}${base_libdir}/firmware/raspberrypi/bootloader-2712/latest

    ln -s default ${D}${base_libdir}/firmware/raspberrypi/bootloader-2711/critical
    ln -s latest ${D}${base_libdir}/firmware/raspberrypi/bootloader-2711/stable
    ln -s latest ${D}${base_libdir}/firmware/raspberrypi/bootloader-2711/beta
    ln -s default ${D}${base_libdir}/firmware/raspberrypi/bootloader-2712/critical
    ln -s latest ${D}${base_libdir}/firmware/raspberrypi/bootloader-2712/stable
    ln -s latest ${D}${base_libdir}/firmware/raspberrypi/bootloader-2712/beta

    # copy default config
    install -d ${D}${sysconfdir}/default
    install -D ${S}/rpi-eeprom-update-default ${D}${sysconfdir}/default/rpi-eeprom-update
}

FILES:${PN} += "${base_libdir}/firmware/raspberrypi/bootloader-*"

INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

# vl805 tool sources are not available (yet), as it comes as a precompiled
# binary only. It has ARM architecture whereas target machine is Aarch64. We
# need to disable arch check for it otherwise it cannot packed.
QAPATHTEST[arch] = ""

COMPATIBLE_MACHINE = "raspberrypi4|raspberrypi4-64|raspberrypi5"

BBCLASSEXTEND = "native"
COMPATIBLE_MACHINE:class-native = ".*"
