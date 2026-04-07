# Copyright 1999-2026 Gentoo Authors
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

src_prepare() {
	default

	# Fix gvisor build tag overlap: runtime_constants_go125.go matches
	# Go 1.26+ too, causing redeclaration errors with runtime_constants_go126.go.
	# Add !go1.26 constraint so only one file compiles per Go version.
	local f="${WORKDIR}/go-mod/gvisor.dev/gvisor@v0.0.0-20251031020517-ecfcdd2f171c/pkg/sync/runtime_constants_go125.go"
	if [[ -f "${f}" ]]; then
		sed -i 's|//go:build go1\.25|//go:build go1.25 \&\& !go1.26|' "${f}" || die
	fi
}

src_compile() {
	cd client || die
	ego build -ldflags "-X 'github.com/netbirdio/netbird/version.version=${PV}'" -o netbird || die
}

src_install() {
	dobin client/netbird

	einstalldocs
}
