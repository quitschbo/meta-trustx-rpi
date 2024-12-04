require raspberrypi-generic.inc

MACHINE="raspberrypi3-64"
MACHINEOVERRIDES =. "raspberrypi3-64:"

TRUSTME_CONTAINER_ARCH = "qemuarm64"

# Kernel image name
KERNEL_IMAGETYPE_DIRECT = "Image"
SDIMG_KERNELIMAGE = "kernel8.img"
