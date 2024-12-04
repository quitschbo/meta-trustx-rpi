KERNEL_IMAGE_FILE = "cml-kernel/${KERNEL_IMAGETYPE_DIRECT}-initramfs-${MACHINE}.bin"
OS_CONFIG_IN := "${THISDIR}/${PN}/${OS_NAME}.conf"
prepare_kernel_conf:append () {
    sed -i "s|%%sdimg_name%%|${SDIMG_KERNELIMAGE}|" "${OS_CONFIG}"
}
