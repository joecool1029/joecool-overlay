# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Restore/upgrade firmware of iOS devices"
HOMEPAGE="https://github.com/libimobiledevice/idevicerestore"
SRC_URI="https://github.com/libimobiledevice/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"

KEYWORDS="~amd64"

RDEPEND="
	>=app-pda/libimobiledevice-1.3.0
	>=app-pda/libirecovery-1.0.0
	net-misc/curl
"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
