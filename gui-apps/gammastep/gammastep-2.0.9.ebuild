# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit autotools flag-o-matic systemd xdg-utils python-r1

DESCRIPTION="A screen color temperature adjusting software (redshift fork)"
HOMEPAGE="https://gitlab.com/chinstrap/gammastep"
SRC_URI="https://gitlab.com/chinstrap/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="appindicator geoclue nls wayland"

COMMON_DEPEND=">=x11-libs/libX11-1.4
	x11-libs/libXxf86vm
	x11-libs/libxcb
	x11-libs/libdrm
	appindicator? ( dev-libs/libappindicator:3[introspection] )
	geoclue? ( app-misc/geoclue:2.0 dev-libs/glib:2 )
	wayland? ( >=dev-util/wayland-scanner-1.15 ) "
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	nls? ( sys-devel/gettext )
"

src_prepare() {
   default
   eautoreconf
}

src_configure() {

	# Fix compile for Clang (bug #732438)
	append-cflags -fPIE

	econf \
		$(use_enable nls) \
		--enable-drm \
		--enable-randr \
		\
		$(use_enable geoclue geoclue2) \
		\
		--disable-gui \
		--with-systemduserunitdir="$(systemd_get_userunitdir)" \
		--enable-apparmor \
		$(use_enable wayland)
}

src_install() {
	emake DESTDIR="${D}" UPDATE_ICON_CACHE=/bin/true install

}
