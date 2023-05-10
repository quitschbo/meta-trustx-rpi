require recipes-kernel/linux/linux-gyroidos.inc

SRC_URI += "\
	file://trustx-rpi.cfg \
"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
