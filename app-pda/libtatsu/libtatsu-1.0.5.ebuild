# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library handling the communication with Apple's Tatsu Signing Server (TSS)"
HOMEPAGE="https://github.com/libimobiledevice/libtatsu"
SRC_URI="https://github.com/libimobiledevice/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

RDEPEND="
	>=app-pda/libplist-2.6.0
	net-misc/curl
"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
