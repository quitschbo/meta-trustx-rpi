DESCRIPTION = "Helper image to deploy secure boot key on RPi 4 + RPi 5"
LICENSE = "MIT & Apache-2.0"

inherit image

DEPENDS += "dosfstools-native mtools-native rpi-eeprom-native openssl-native"
IMAGE_FSTYPES = "vfat"

RPI_EEPROM:raspberrypi4-64 = "bootloader-2711/default/pieeprom-2023-01-11.bin"
RPI_RECOVERY:raspberrypi4-64 = "bootloader-2711/default/recovery.bin"
BOOT_CONF:raspberrypi4-64 = "boot4.conf"
RPI_EEPROM:raspberrypi5 = "bootloader-2712/latest/pieeprom-2025-01-22.bin"
RPI_RECOVERY:raspberrypi5 = "bootloader-2712/latest/recovery.bin"
BOOT_CONF:raspberrypi5 = "boot5.conf"

prepare_eeprom () {
  cp "${RECIPE_SYSROOT_NATIVE}/usr/lib/firmware/raspberrypi/${RPI_EEPROM}" "${B}/pieeprom.bin"
}

do_rootfs () {
  prepare_eeprom

  # extract first certificate in secure boot cert chain
  openssl x509 -in "${SECURE_BOOT_SIG_CERT}" > "${B}/secure_boot.cert"

  cp "${THISDIR}/${PN}/${BOOT_CONF}" "${B}/boot.conf"

  # update_eeprom
  rpi-eeprom-digest \
        -i "${B}/boot.conf" \
        -o "${B}/boot.conf.sig" \
        -k "${SECURE_BOOT_SIG_KEY}"

  rpi-eeprom-config \
        --config "${B}/boot.conf" \
        --out "${IMAGE_ROOTFS}/pieeprom.bin" \
        -d "${B}/boot.conf.sig" \
        -p "${B}/secure_boot.cert" \
        "${B}/pieeprom.bin"

  # image_digest
  rpi-eeprom-digest \
        -i "${IMAGE_ROOTFS}/pieeprom.bin" \
        -o "${IMAGE_ROOTFS}/pieeprom.sig"

  cp "${RECIPE_SYSROOT_NATIVE}/usr/lib/firmware/raspberrypi/${RPI_RECOVERY}" "${IMAGE_ROOTFS}/"
}
ROOTFS_PREPROCESS_COMMAND += "return;"

# backported from scarthgap
oe_mkvfatfs () {
    mkfs.vfat $@ -C ${IMGDEPLOYDIR}/${IMAGE_NAME}.vfat ${ROOTFS_SIZE}
    mcopy -i "${IMGDEPLOYDIR}/${IMAGE_NAME}.vfat" -vsmpQ ${IMAGE_ROOTFS}/* ::/
    ln -sf "${IMAGE_NAME}.vfat" "${IMGDEPLOYDIR}/${PN}-${MACHINE}.vfat"
}
IMAGE_CMD:vfat = "oe_mkvfatfs ${EXTRA_IMAGECMD}"
