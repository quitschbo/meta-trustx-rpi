# updated versions also used in scarthgap
RPIFW_DATE = "20240319"
SRCREV = "9f24f4bc2bdd07ffd158cfbb4bce88a2efc4c1f5"
SHORTREV = "${@d.getVar("SRCREV", False).__str__()[:7]}"

RPIFW_SRC_URI = "https://api.github.com/repos/raspberrypi/firmware/tarball/9f24f4bc2bdd07ffd158cfbb4bce88a2efc4c1f5;downloadfilename=raspberrypi-firmware-${SHORTREV}.tar.gz"
RPIFW_S = "${WORKDIR}/raspberrypi-firmware-${SHORTREV}"

SRC_URI = "${RPIFW_SRC_URI}"
SRC_URI[sha256sum] = "4b436f8946b139c6a1202375ef55d4848e3bcd8c1a9cb47000e06d7ecec828f7"
