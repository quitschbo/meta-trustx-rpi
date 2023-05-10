INITRAMFS_IMAGE_BUNDLE = "1"
INITRAMFS_IMAGE = "trustx-cml-initramfs"

TRUSTME_FSTYPES = "trustmerpi"
TRUSTME_PARTTABLE_TYPE="msdos"

TRUSTME_HARDWARE = "arm"
TRUSTME_LOGTTY = "tty11"

PACKAGE_CLASSES = "package_ipk"
BBMULTICONFIG = "container"

PREFERRED_PROVIDER_virtual/kernel ?= "linux-raspberrypi"
PREFERRED_PROVIDER_virtual/kernel:gyroidos-cml ?= "linux-raspberrypi"
PREFERRED_VERSION_linux-raspberrypi = "5.15.%"

RPI_KERNEL_DEVICETREE_OVERLAYS:append = " overlays/tpm-slb9670.dtbo"
RPI_EXTRA_CONFIG = "dtoverlay=tpm-slb9670"
ENABLE_SPI_BUS = "1"

CMDLINE:append = " cgroup_enable=memory lsm=integrity"
MACHINE_FEATURES:append = " armstub"
