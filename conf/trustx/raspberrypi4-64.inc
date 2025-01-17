require raspberrypi-generic.inc

MACHINE="raspberrypi4-64"
MACHINEOVERRIDES =. "raspberrypi4-64:"

TRUSTME_CONTAINER_ARCH = "qemuarm64"

# if SERIAL_CONSOLES is set and ENABLE_UART is false, getty will flood
# the LOGTTY with error messages. Clear SERIAL_CONSOLES to silence errors.
python () {
    if not d.getVar('ENABLE_UART', True) or d.getVar('ENABLE_UART', True) == "0":
        d.setVar('SERIAL_CONSOLES', "")
}
