# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="A tool to create DjVu files from PDF files"
HOMEPAGE="https://github.com/jwilk-archive/pdf2djvu"
SRC_URI="https://github.com/jwilk/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+graphicsmagick nls openmp"

RDEPEND="
	>=app-text/djvu-3.5.21:=
	>=app-text/poppler-25.09.0:=
	dev-libs/libxml2:=
	dev-libs/libxslt:=
	graphicsmagick? ( media-gfx/graphicsmagick:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS=(
	doc/{changelog,credits,djvudigital,README}
)

PATCHES=(
	"${FILESDIR}/poppler-25.08.0-build-fix.patch"
	"${FILESDIR}/poppler-25.10.0-build-fix.patch"
	"${FILESDIR}/poppler-26.01.0-build-fix.patch"
	"${FILESDIR}/poppler-26.02.0-build-fix.patch"
)

src_prepare() {
   default
   eautoreconf
}

src_configure() {
	local openmp=--disable-openmp
	use openmp && tc-check-openmp && openmp=--enable-openmp

	append-cxxflags "-std=c++20"

	econf \
		${openmp} \
		$(use_enable nls) \
		$(use_with graphicsmagick)
}
