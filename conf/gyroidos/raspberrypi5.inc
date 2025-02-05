require raspberrypi-generic.inc

MACHINE="raspberrypi5"
MACHINEOVERRIDES =. "raspberrypi5:"

GYROIDOS_CONTAINER_ARCH = "qemuarm64"

# enable compressed kernel image
KERNEL_IMAGETYPE_DIRECT = "Image.gz"

# currently not included by meta-raspberrypi
RPI_KERNEL_DEVICETREE:append = " broadcom/bcm2712-rpi-500.dtb"

# if SERIAL_CONSOLES is set and ENABLE_UART is false, getty will flood
# the LOGTTY with error messages. Clear SERIAL_CONSOLES to silence errors.
python () {
    if not d.getVar('ENABLE_UART', True) or d.getVar('ENABLE_UART', True) == "0":
        d.setVar('SERIAL_CONSOLES', "")
}
