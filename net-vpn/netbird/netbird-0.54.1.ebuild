# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="netbird VPN client-only ebuild"

HOMEPAGE="https://netbird.io/"

SRC_URI="https://github.com/netbirdio/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	http://joecool.ftfuchs.com/godeps/${P}-deps.tar.xz"

LICENSE="AGPL-3 BSD"
SLOT="0"

KEYWORDS="~amd64"

src_compile() {
	cd client || die
	ego build -ldflags "-X 'github.com/netbirdio/netbird/version.version=${PV}'" -o netbird || die
}

src_install() {
	dobin client/netbird

	default
}
