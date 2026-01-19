# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A command-line tool to extract metadata from torrent files"
HOMEPAGE="https://github.com/tomcdj71/dumptorrent"
SRC_URI="https://github.com/tomcdj71/dumptorrent/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_install() {
	dobin "${BUILD_DIR}"/dumptorrent || die
	dobin "${BUILD_DIR}"/scrapec || die
	dodoc README.md
}
