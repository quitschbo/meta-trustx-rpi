KERNEL_IMAGE_FILE = "cml-kernel/zImage-initramfs-${MACHINE}.bin"
OS_CONFIG_IN := "${THISDIR}/${PN}/${OS_NAME}.conf"
prepare_kernel_conf:append () {
    sed -i "s|%%sdimg_name%%|${SDIMG_KERNELIMAGE}|" "${OS_CONFIG}"
}
