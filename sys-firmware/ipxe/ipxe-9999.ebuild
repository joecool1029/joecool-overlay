# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils git-2

DESCRIPTION="iPXE Open Source Boot Firmware"
HOMEPAGE="http://ipxe.org/"
SRC_URI=""

EGIT_REPO_URI="git://git.ipxe.org/${PN}.git"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="iso +qemu undi usb vmware"

DEPEND="sys-devel/make
        dev-lang/perl
        sys-libs/zlib
        iso? (
                sys-boot/syslinux
                virtual/cdrtools
        )"
RDEPEND=""

src_unpack() {
	git-2_src_unpack
	cd ${P}
	#epatch ${FILESDIR}/ipxe-asm.patch
}

src_configure() {
	cd src
        if use vmware; then
                sed -i config/sideband.h \
                        -e 's|//#define[[:space:]]VMWARE_SETTINGS|#define VMWARE_SETTINGS|'
                sed -i config/console.h \
                        -e 's|//#define[[:space:]]CONSOLE_VMWARE|#define CONSOLE_VMWARE|'
        fi
}

src_compile() {
        cd src
        if use qemu; then
                emake bin/808610de.rom # pxe-e1000.rom
                emake bin/80861209.rom # pxe-eepro100.rom
                emake bin/10500940.rom # pxe-ne2k_pci.rom
                emake bin/10222000.rom # pxe-pcnet.rom
                emake bin/10ec8139.rom # pxe-rtl8139.rom
                emake bin/1af41000.rom # pxe-virtio.rom
		emake bin/8086100e.rom # e1000-rom
                fi

        if use vmware; then
                emake bin/8086100f.mrom # e1000
                emake bin/808610d3.mrom # e1000e
                emake bin/10222000.mrom # vlance
                emake bin/15ad07b0.rom # vmxnet3
        fi

        use iso && emake bin/ipxe.iso
        use undi && emake bin/undionly.kpxe
        use usb && emake bin/ipxe.usb
}

src_install() {
	cd src
        insinto /usr/share/ipxe/

        if use qemu || use vmware; then
                doins bin/*.rom
        fi
        use vmware && doins bin/*.mrom
        use iso && doins bin/*.iso
        use undi && doins bin/*.kpxe
        use usb && doins bin/*.usb
}
