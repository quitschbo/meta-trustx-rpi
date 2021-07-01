# disable warnings for cast align on 32bit
WCAST_ALIGN_raspberrypi2 = "n"
EXTRA_OEMAKE += "WCAST_ALIGN=${WCAST_ALIGN}"
