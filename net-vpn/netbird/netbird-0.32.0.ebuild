# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="netbird VPN client-only ebuild"

HOMEPAGE="https://netbird.io/"

SRC_URI="https://github.com/netbirdio/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://joecool.ftfuchs.com/${P}-deps.tar.xz"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64"

src_compile() {
	cd client || die
	ego build -o netbird || die
}

src_install() {
	dobin client/netbird

	default
}
