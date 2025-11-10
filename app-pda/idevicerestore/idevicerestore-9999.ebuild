# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3
EGIT_REPO_URI="https://github.com/libimobiledevice/idevicerestore.git"

DESCRIPTION="Restore/upgrade firmware of iOS devices"
HOMEPAGE="https://github.com/libimobiledevice/idevicerestore"

LICENSE="LGPL-3"
SLOT="0"

#KEYWORDS="~amd64"

RDEPEND="
	>=app-pda/libimobiledevice-1.4.0
	>=app-pda/libirecovery-1.3.0
	net-misc/curl
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
