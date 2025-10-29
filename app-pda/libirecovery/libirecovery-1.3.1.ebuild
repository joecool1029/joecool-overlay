# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library and utility to talk to iBoot/iBSS via USB on Mac OS X, Windows, and Linux "
HOMEPAGE="https://github.com/libimobiledevice/libirecovery"
SRC_URI="https://github.com/libimobiledevice/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

RDEPEND="
	app-pda/libimobiledevice-glue
"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
