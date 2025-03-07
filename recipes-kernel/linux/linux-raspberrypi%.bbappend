require recipes-kernel/linux/linux-gyroidos.inc

# enable buildhistory for this recipe to allow SRCREV extraction
inherit buildhistory
BUILDHISTORY_COMMIT = "0"

SRC_URI += "\
	file://gyroidos-rpi.cfg \
"
LINUX_VERSION_EXTENSION = "-gyroidos"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-raspberrypi:"

# upstream kernel repo dropped bcmrpi3_defconfig, use ours
KBUILD_DEFCONFIG:raspberrypi3-64 = ""
SRC_URI:append:raspberrypi3-64 = "file://bcmrpi3_defconfig"
