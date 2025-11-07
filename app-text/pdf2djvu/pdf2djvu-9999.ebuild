# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3 flag-o-matic toolchain-funcs
EGIT_REPO_URI="https://github.com/FriedrichFroebel/${PN}.git"

DESCRIPTION="A tool to create DjVu files from PDF files"
HOMEPAGE="https://github.com/FriedrichFroebel/pdf2djvu"

LICENSE="GPL-2"
SLOT="0"
IUSE="+graphicsmagick nls openmp"

RDEPEND="
	>=app-text/djvu-3.5.21:=
	>=app-text/poppler-0.16.7:=
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

src_prepare() {
	default
	private/autogen || die
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
