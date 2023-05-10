inherit trustmegeneric

#
# Create an partitioned trustme image that can be copied to an SD card
#

# Set kernel and boot loader
IMAGE_BOOTLOADER ?= "bootfiles"

# Kernel image name
SDIMG_KERNELIMAGE:raspberrypi  ?= "kernel.img"
SDIMG_KERNELIMAGE:raspberrypi2 ?= "kernel7.img"
SDIMG_KERNELIMAGE:raspberrypi3-64 ?= "kernel8.img"

do_image_trustmerpi[depends] = " \
    virtual/kernel:do_deploy \
    rpi-${IMAGE_BOOTLOADER}:do_deploy \
    ${@bb.utils.contains('MACHINE_FEATURES', 'armstub', 'armstubs:do_deploy', '' ,d)} \
    ${@bb.utils.contains('RPI_USE_U_BOOT', '1', 'u-boot:do_deploy', '',d)} \
    ${@bb.utils.contains('RPI_USE_U_BOOT', '1', 'rpi-u-boot-scr:do_deploy', '',d)} \
"

do_image_trustmerpi[depends] += " ${TRUSTME_GENERIC_DEPENDS} "

do_image_trustmerpi[recrdeps] = "do_build"

do_rpi_bootpart () {
	rm -fr ${TRUSTME_BOOTPART_DIR}

	if [ -z "${DEPLOY_DIR_IMAGE}" ];then
		bbfatal "Cannot get bitbake variable \"DEPLOY_DIR_IMAGE\""
		exit 1
	fi

	if [ -z "${TRUSTME_BOOTPART_DIR}" ];then
		bbfatal "Cannot get bitbake variable \"TRUSTME_BOOTPART_DIR\""
		exit 1
	fi
	# Check if we are building with device tree support
	DTS="${@make_dtb_boot_files(d)}"

	bbnote "Copying boot partition files to ${TRUSTME_BOOTPART_DIR}"

	machine=$(echo "${MACHINE}" | tr "_" "-")
	bbdebug 1 "Boot machine: $machine"

	rm -fr "${TRUSTME_BOOTPART_DIR}"
	install -d "${TRUSTME_BOOTPART_DIR}/tmp"

	cp --dereference "${DEPLOY_DIR_IMAGE}/${IMAGE_BOOTLOADER}/"* "${TRUSTME_BOOTPART_DIR}"

	if [ "${@bb.utils.contains("MACHINE_FEATURES", "armstub", "1", "0", d)}" = "1" ]; then
		cp --dereference "${DEPLOY_DIR_IMAGE}/armstubs/${ARMSTUB}" "${TRUSTME_BOOTPART_DIR}"
	fi

	if [ -n "${DTS}" ]; then
		# Copy board device trees (including overlays)
		install -d ${TRUSTME_BOOTPART_DIR}/overlays
		for entry in ${DTS} ; do
			# Split entry at optional ';'
			if [ $(echo "$entry" | grep -c \;) = "0" ] ; then
			    DEPLOY_FILE="$entry"
			    DEST_FILENAME="$entry"
			else
			    DEPLOY_FILE="$(echo "$entry" | cut -f1 -d\;)"
			    DEST_FILENAME="$(echo "$entry" | cut -f2- -d\;)"
			fi
			cp --dereference "${DEPLOY_DIR_IMAGE}/cml-kernel/${DEPLOY_FILE}" "${TRUSTME_BOOTPART_DIR}/${DEST_FILENAME}"
		done
	fi

	if [ "${RPI_USE_U_BOOT}" = "1" ]; then
		cp --dereference "${DEPLOY_DIR_IMAGE}/u-boot.bin" "${TRUSTME_BOOTPART_DIR}/${SDIMG_KERNELIMAGE}"
		cp --dereference "${DEPLOY_DIR_IMAGE}/boot.scr" "${TRUSTME_BOOTPART_DIR}/boot.scr"
		if [ ! -z "${INITRAMFS_IMAGE}" -a "${INITRAMFS_IMAGE_BUNDLE}" = "1" ]; then
			cp --dereference "${DEPLOY_DIR_IMAGE}/cml-kernel/${KERNEL_IMAGETYPE}-${INITRAMFS_LINK_NAME}.bin" "${TRUSTME_BOOTPART_DIR}/${KERNEL_IMAGETYPE}"
		else
			cp --dereference "${DEPLOY_DIR_IMAGE}/cml-kernel/${KERNEL_IMAGETYPE}" "${TRUSTME_BOOTPART_DIR}/${KERNEL_IMAGETYPE}"
		fi
	else
		if [ ! -z "${INITRAMFS_IMAGE}" -a "${INITRAMFS_IMAGE_BUNDLE}" = "1" ]; then
			cp --dereference "${DEPLOY_DIR_IMAGE}/cml-kernel/${KERNEL_IMAGETYPE}-${INITRAMFS_LINK_NAME}.bin" "${TRUSTME_BOOTPART_DIR}/${SDIMG_KERNELIMAGE}"
		else
			cp --dereference "${DEPLOY_DIR_IMAGE}/cml-kernel/${KERNEL_IMAGETYPE}" "${TRUSTME_BOOTPART_DIR}/${SDIMG_KERNELIMAGE}"
		fi
	fi

	bbnote  "Created rpi boot files at ${TRUSTME_BOOTPART_DIR}/"
	rm -fr "${TRUSTME_BOOTPART_DIR}/tmp/"
}


IMAGE_CMD:trustmerpi () {
	bbnote  "Using standard trustme partition"
	do_rpi_bootpart
	do_build_trustmeimage
}

