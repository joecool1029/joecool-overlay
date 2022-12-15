# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
EGIT_REPO_URI="https://bitbucket.org/mmueller2012/pipelight.git"

inherit multilib toolchain-funcs git-2

DESCRIPTION="Run Silverlight applications directly in the browser using Wine"
HOMEPAGE="https://launchpad.net/pipelight"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

CDEPEND="x11-libs/libX11
	cross-mingw32/gcc[cxx]"

DEPEND="${CDEPEND}
	cross-mingw32/w32api"

RDEPEND="${CDEPEND}
	app-emulation/wine[abi_x86_32]"

src_prepare() {
	local GCCVER=$(CHOST="mingw32" gcc-fullversion)
	local GCCLIB="${EPREFIX}/usr/$(get_libdir)/gcc/mingw32/${GCCVER}"

	# Change installation directory.
	sed -i "s:/lib/mozilla/:/$(get_libdir)/nsbrowser/:g" \
		Makefile || die

	# Use our mingw32 toolchain.
	sed -i "s:i686-w64-mingw32:mingw32:g" \
		src/windows/Makefile || die

	# Fix the location of GCC's libraries.
	sed -i -r "s:(#define DEFAULT_GCC_RUNTIME_DLL_SEARCH_PATH ).*:\1\"${GCCLIB}\":g" \
		src/linux/configloader.h || die

	# Use the wine found in PATH.
	sed -i -r "s:^(winePath[^=]*=).*:\1 wine:" \
		share/pipelight || die
}

src_configure() {
	# Don't use econf, not a normal configure script.
	./configure --prefix="${EPREFIX}/usr" || die
}
