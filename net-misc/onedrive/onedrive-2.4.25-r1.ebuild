# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Free Client for OneDrive on Linux"
HOMEPAGE="https://abraunegg.github.io/"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
PATCHES="${FILESDIR}"/${P}-gdc.patch

RDEPEND="
	>=dev-db/sqlite-3.7.15:3
	net-misc/curl
	libnotify? ( x11-libs/libnotify )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
BDEPEND="
	${DEPEND}
	>=sys-devel/gcc-12.1.0[d]
"
SRC_URI="https://codeload.github.com/abraunegg/onedrive/tar.gz/v${PV} -> ${P}.tar.gz"
IUSE="debug libnotify"

src_install() {
	emake DESTDIR="${D}" docdir=/usr/share/doc/${PF} install
	# log directory
	keepdir /var/log/onedrive
	fperms 775 /var/log/onedrive
	fowners root:users /var/log/onedrive
	# init script
	dobin contrib/init.d/onedrive_service.sh
	newinitd contrib/init.d/onedrive.init onedrive
}

pkg_postinst() {
	elog "OneDrive Free Client needs to be authorized to access your data before the"
	elog "first use. To do so, run onedrive in a terminal for the user in question and"
	elog "follow the steps on screen."
	elog
}
