KERNEL_IMAGE_FILE = "cml-kernel/${KERNEL_IMAGETYPE_DIRECT}-initramfs-${MACHINE}.bin"
OS_CONFIG_IN := "${THISDIR}/${PN}/${OS_NAME}.conf"
prepare_kernel_conf:append () {
    sed -i "s|%%sdimg_name%%|${SDIMG_KERNELIMAGE}|" "${OS_CONFIG}"
}

DEPENDS:append:raspberrypi4-64 = " rpi-eeprom-native"
WICVARS:append:raspberrypi4-64 = " SECURE_BOOT_SIG_KEY"
DEPENDS:append:raspberrypi5 = " rpi-eeprom-native"
WICVARS:append:raspberrypi5 = " SECURE_BOOT_SIG_KEY"
