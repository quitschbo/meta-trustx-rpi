require recipes-kernel/linux/linux-gyroidos.inc

SRC_URI += "\
	file://gyroidos-rpi.cfg \
"
LINUX_VERSION_EXTENSION = "-gyroidos"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-raspberrypi:"
