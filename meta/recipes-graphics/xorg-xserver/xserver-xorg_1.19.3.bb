require xserver-xorg.inc

SRC_URI += "file://musl-arm-inb-outb.patch \
            file://0001-configure.ac-Fix-check-for-CLOCK_MONOTONIC.patch \
            file://0002-configure.ac-Fix-wayland-scanner-and-protocols-locat.patch \
            file://0003-modesetting-Fix-16-bit-depth-bpp-mode.patch \
            file://0003-Remove-check-for-useSIGIO-option.patch \
            file://CVE-2017-10971-1.patch \
            file://CVE-2017-10971-2.patch \
            file://CVE-2017-10971-3.patch \
            file://CVE-2017-12176.patch \
            file://CVE-2017-12177.patch \
            file://CVE-2017-12178.patch \
            file://CVE-2017-12180-CVE-2017-12181-CVE-2017-12182.patch \
            file://CVE-2017-12183.patch \
            file://CVE-2017-12184-CVE-2017-12185-CVE-2017-12186-CVE-2017-12187.patch \
            file://0001-Xi-Test-exact-size-of-XIBarrierReleasePointer.patch \
            file://CVE-2017-12179.patch \
            file://CVE-2017-13721.patch \
            file://CVE-2017-13723.patch \
            file://0001-dri2-Sync-i965_pci_ids.h-from-Mesa.patch \
            file://0002-dri2-Sync-i965_pci_ids.h-from-Mesa.patch \
            file://0003-dri2-Sync-i965_pci_ids.h-from-Mesa.patch \
            file://0001-config-wait-for-DRM-device-to-be-successful-initiate.patch \
            file://0002-fbdevhw-add-loop-to-wait-dev-fb0-get-ready.patch \
            "
SRC_URI[md5sum] = "015d2fc4b9f2bfe7a626edb63a62c65e"
SRC_URI[sha256sum] = "677a8166e03474719238dfe396ce673c4234735464d6dadf2959b600d20e5a98"

# These extensions are now integrated into the server, so declare the migration
# path for in-place upgrades.

RREPLACES_${PN} =  "${PN}-extension-dri \
                    ${PN}-extension-dri2 \
                    ${PN}-extension-record \
                    ${PN}-extension-extmod \
                    ${PN}-extension-dbe \
                   "
RPROVIDES_${PN} =  "${PN}-extension-dri \
                    ${PN}-extension-dri2 \
                    ${PN}-extension-record \
                    ${PN}-extension-extmod \
                    ${PN}-extension-dbe \
                   "
RCONFLICTS_${PN} = "${PN}-extension-dri \
                    ${PN}-extension-dri2 \
                    ${PN}-extension-record \
                    ${PN}-extension-extmod \
                    ${PN}-extension-dbe \
                   "
