require raspberrypi-generic.inc

MACHINE="raspberrypi3-64"
MACHINEOVERRIDES =. "raspberrypi3-64:"

GYROIDOS_CONTAINER_ARCH = "qemuarm64"

# Kernel image name
KERNEL_IMAGETYPE_DIRECT = "Image"
SDIMG_KERNELIMAGE = "kernel8.img"

# if SERIAL_CONSOLES is set and ENABLE_UART is false, getty will flood
# the LOGTTY with error messages. Clear SERIAL_CONSOLES to silence errors.
python () {
    if not d.getVar('ENABLE_UART', True):
        d.setVar('SERIAL_CONSOLES', "")
}
