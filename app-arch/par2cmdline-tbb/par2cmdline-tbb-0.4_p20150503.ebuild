# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A PAR-2.0 file verification and repair tool (tbb fork)"
HOMEPAGE="https://github.com/jcfp/par2tbb-chuchusoft-sources"
SRC_URI="https://github.com/jcfp/par2tbb-chuchusoft-sources/releases/download/0.4-tbb-20150503/par2cmdline-0.4-tbb-20150503.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/par2cmdline-0.4"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES="${FILESDIR}"/${PN}-dropsysctl.patch

DEPEND="~dev-cpp/tbb-2020.3"
RDEPEND="
	!app-arch/par2cmdline
	!app-arch/par2cmdline-turbo
"

src_test() {
	# test22 fails when run in parallel
	emake -j1 check
}
