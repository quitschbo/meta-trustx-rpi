LINUX_VERSION ?= "5.15.44"
LINUX_RPI_BRANCH ?= "rpi-5.15.y"
LINUX_RPI_KMETA_BRANCH ?= "yocto-5.15"

SRCREV_machine = "ea7fe1b21ea73146b1d49ac5f554fbd0ac5de9de"
SRCREV_meta = "e1b976ee4fb5af517cf01a9f2dd4a32f560ca894"

KMETA = "kernel-meta"

SRC_URI = " \
    git://github.com/raspberrypi/linux.git;name=machine;branch=${LINUX_RPI_BRANCH};protocol=https \
    git://git.yoctoproject.org/yocto-kernel-cache;type=kmeta;name=meta;branch=${LINUX_RPI_KMETA_BRANCH};destsuffix=${KMETA} \
    "

require recipes-kernel/linux/linux-raspberrypi.inc

SRC_URI_remove = "file://rpi-kernel-misc.cfg"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

KERNEL_EXTRA_ARGS_append_rpi = " DTC_FLAGS='-@ -H epapr'"
