require grub2.inc

RDEPENDS_${PN}-common = "${PN}-editenv"
RDEPENDS_${PN} = "diffutils freetype ${PN}-common"

PACKAGES =+ "${PN}-editenv ${PN}-common"

FILES_${PN}-editenv = "${bindir}/grub-editenv"
FILES_${PN}-common = " \
    ${bindir} \
    ${sysconfdir} \
    ${sbindir} \
    ${datadir}/grub \
"

do_install_append () {
    install -d ${D}${sysconfdir}/grub.d
}

INSANE_SKIP_${PN} = "arch"
INSANE_SKIP_${PN}-dbg = "arch"
