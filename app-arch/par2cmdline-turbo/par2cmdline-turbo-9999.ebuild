# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

if [[ ${PV} == 9999 ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/animetosho/par2cmdline-turbo"
else
	SRC_URI="https://github.com/Parchive/${PN}/releases/download/v${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux"
fi

DESCRIPTION="par2cmdline × ParPar: speed focused par2cmdline fork"
HOMEPAGE="https://github.com/animetosho/par2cmdline-turbo"

LICENSE="GPL-2"
SLOT="0"
IUSE="openmp"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default
	eautoreconf
}

src_test() {
	# test22 fails when run in parallel
	emake -j1 check
}