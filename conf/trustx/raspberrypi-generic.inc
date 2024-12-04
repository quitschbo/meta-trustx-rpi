INITRAMFS_IMAGE_BUNDLE = "1"
INITRAMFS_IMAGE = "trustx-cml-initramfs"

IMAGE_FSTYPES = "cpio ext4"
TRUSTME_FSTYPES = "wic wic.bmap"
TRUSTME_BOOTPART_FS = "vfat"
TRUSTME_PARTTABLE_TYPE = "msdos"

TRUSTME_TARGET_ALIGN = "4096"

TRUSTME_HARDWARE = "arm"
TRUSTME_LOGTTY = "tty11"

PACKAGE_CLASSES = "package_ipk"
BBMULTICONFIG = "container"

PREFERRED_PROVIDER_virtual/kernel ?= "linux-raspberrypi-dev"
PREFERRED_PROVIDER_virtual/kernel:gyroidos-cml ?= "linux-raspberrypi-dev"
#PREFERRED_VERSION_linux-raspberrypi = "5.15.%"
LINUX_VERSION := "6.12.y"
LINUX_RPI_BRANCH := "rpi-6.12.y"

# overwrite device tree with new locations in kernel v6.x
RPI_KERNEL_DEVICETREE ?= " \
    broadcom/bcm2708-rpi-zero.dtb \
    broadcom/bcm2708-rpi-zero-w.dtb \
    broadcom/bcm2708-rpi-b.dtb \
    broadcom/bcm2708-rpi-b-rev1.dtb \
    broadcom/bcm2708-rpi-b-plus.dtb \
    broadcom/bcm2709-rpi-2-b.dtb \
    broadcom/bcm2710-rpi-2-b.dtb \
    broadcom/bcm2710-rpi-3-b.dtb \
    broadcom/bcm2710-rpi-3-b-plus.dtb \
    broadcom/bcm2710-rpi-zero-2.dtb \
    broadcom/bcm2711-rpi-4-b.dtb \
    broadcom/bcm2711-rpi-400.dtb \
    broadcom/bcm2708-rpi-cm.dtb \
    broadcom/bcm2710-rpi-cm3.dtb \
    broadcom/bcm2711-rpi-cm4.dtb \
    broadcom/bcm2711-rpi-cm4s.dtb \
"

RPI_KERNEL_DEVICETREE_OVERLAYS:append = " overlays/tpm-slb9670.dtbo"
RPI_EXTRA_CONFIG = "dtoverlay=tpm-slb9670"
ENABLE_SPI_BUS = "1"

CMDLINE:append = " lsm=integrity"
MACHINE_FEATURES:append = " armstub"

def make_dtb_boot_files(d):
    # Generate IMAGE_BOOT_FILES entries for device tree files listed in
    # KERNEL_DEVICETREE.
    alldtbs = d.getVar('KERNEL_DEVICETREE')

    prefix = d.getVar('KERNEL_DEPLOYSUBDIR')
    if prefix != "" :
        prefix = prefix + "/"

    def transform(dtb):
        base = os.path.basename(dtb)
        if dtb.endswith('dtbo') or base == 'overlay_map.dtb':
            # overlay dtb:
            # eg: overlays/hifiberry-amp.dtbo has:
            #     DEPLOYDIR file: hifiberry-amp.dtbo
            #     destination: overlays/hifiberry-amp.dtbo
            return '{}{};{}'.format(prefix, base, dtb)
        elif dtb.endswith('dtb'):
            # eg: whatever/bcm2708-rpi-b.dtb has:
            #     DEPLOYDIR file: bcm2708-rpi-b.dtb
            #     destination: bcm2708-rpi-b.dtb
            return '{}{};{}'.format(prefix, base, base)

    return ' '.join([transform(dtb) for dtb in alldtbs.split(' ') if dtb])

IMAGE_BOOT_FILES = "${BOOTFILES_DIR_NAME}/* \
                 ${@make_dtb_boot_files(d)} \
                 ${KERNEL_DEPLOYSUBDIR}/zImage-initramfs-${MACHINE}.bin;${SDIMG_KERNELIMAGE}"

WKS_FILE:${MACHINE} = "trustx-cml.raspberrypi.wks.in"
