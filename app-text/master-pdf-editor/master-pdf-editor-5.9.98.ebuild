# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Master PDF Editor - complete solution for PDF documents"
HOMEPAGE="https://code-industry.net/free-pdf-editor/"
SRC_URI="https://code-industry.net/public/${PN}-${PV}-1-qt6.x86_64.tar.gz"
S="${WORKDIR}/${PN}-5"

LICENSE="all-rights-reserved"
SLOT="0"
# Not going to run with qt6 built with -fno-direct-extern-access. 
# I have a workaround, it's really ugly though, for now this ebuild
# will give a starting point, but you need to modify qtwidget/qtbase
# and point this to it to run it successfully.
#KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror strip"

RDEPEND="
	app-arch/bzip2:=
	dev-libs/openssl:=
	dev-libs/pkcs11-helper
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,dbus,gui,network,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	media-gfx/sane-backends
	media-libs/freetype
	media-libs/libpng:=
	net-print/cups
"

QA_PREBUILT="opt/${PN}-5/masterpdfeditor5"

BDEPEND="sys-devel/binutils"

src_install() {
	local installdir="/opt/${PN}-5"

	exeinto "${installdir}"
	doexe masterpdfeditor5

	insinto "${installdir}"
	doins -r fonts icc_profiles lang stamps templates
	doins masterpdfeditor5.png license_en.txt

	domenu usr/share/applications/net.code-industry.masterpdfeditor5.desktop

	local size
	for size in 16 32 64 96 128 256; do
		doicon -s "${size}" "usr/share/icons/hicolor/${size}x${size}/apps/masterpdfeditor5.png"
	done
}
