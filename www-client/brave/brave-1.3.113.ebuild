# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit check-reqs git-r3 python-any-r1 flag-o-matic desktop xdg-utils

DESCRIPTION="Brave is a free and open-source web browser"
HOMEPAGE="https://brave.com/"
EGIT_REPO_URI="https://github.com/brave/brave-browser"
EGIT_COMMIT="v1.3.113"
EGIT_SUBMODULES=()

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="+closure-compile cups gnome-keyring kerberos pulseaudio +hangouts +tcmalloc +widevine -system-icu selinux -system-libvpx -system-ffmpeg"

## ISSUES.
# 
# * there is a way to generate the desktop file directly from source.
# * the older versions of sandbox segfault. we need >= 2.17.
# * cross-compilation probably does not work.

# FEATURES="keepwork" can be used to avoid re-downloading the complete source code,
# which as of the time of writing this is around 20 GB in total.

COMMON_DEPEND="
	>=app-accessibility/at-spi2-atk-2.26:2
	app-arch/bzip2:=
	cups? ( >=net-print/cups-1.3.11:= )
	>=dev-libs/atk-2.26
	dev-libs/expat:=
	dev-libs/glib:2
	system-icu? ( >=dev-libs/icu-65:= )
	>=dev-libs/libxml2-2.9.4-r3:=[icu]
	dev-libs/libxslt:=
	dev-libs/nspr:=
	>=dev-libs/nss-3.26:=
	>=dev-libs/re2-0.2019.08.01:=
	gnome-keyring? ( >=gnome-base/libgnome-keyring-3.12:= )
	>=media-libs/alsa-lib-1.0.19:=
	media-libs/fontconfig:=
	media-libs/freetype:=
	>=media-libs/harfbuzz-2.4.0:0=[icu(-)]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	system-libvpx? ( media-libs/libvpx:=[postproc,svc] )
	>=media-libs/openh264-1.6.0:=
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? (
		>=media-video/ffmpeg-4:=
		|| (
			media-video/ffmpeg[-samba]
			>=net-fs/samba-4.5.10-r1[-debug(-)]
		)
		!=net-fs/samba-4.5.12-r0
		>=media-libs/opus-1.3.1:=
	)
	sys-apps/dbus:=
	sys-apps/pciutils:=
	virtual/udev
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11:=
	x11-libs/libXcomposite:=
	x11-libs/libXcursor:=
	x11-libs/libXdamage:=
	x11-libs/libXext:=
	x11-libs/libXfixes:=
	>=x11-libs/libXi-1.6.0:=
	x11-libs/libXrandr:=
	x11-libs/libXrender:=
	x11-libs/libXScrnSaver:=
	x11-libs/libXtst:=
	x11-libs/pango:=
	app-arch/snappy:=
	media-libs/flac:=
	>=media-libs/libwebp-0.4.0:=
	sys-libs/zlib:=[minizip]
	kerberos? ( virtual/krb5 )
"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	!<www-plugins/chrome-binary-plugins-57
	x11-misc/xdg-utils
	virtual/opengl
	virtual/ttf-fonts
	selinux? ( sec-policy/selinux-chromium )
	tcmalloc? ( !<x11-drivers/nvidia-drivers-331.20 )
"
BDEPEND="
${PYTHON_DEPS}
	>=sys-apps/sandbox-2.17
	>=app-arch/gzip-1.7
	dev-lang/perl
	dev-util/gn
	dev-vcs/git
	>=dev-util/gperf-3.0.3
	>=dev-util/ninja-1.7.2
	>=net-libs/nodejs-7.6.0[inspector]
	sys-apps/hwids[usb(+)]
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	closure-compile? ( virtual/jre )
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/chromium-compiler-r10.patch"
	"${FILESDIR}/chromium-fix-char_traits.patch"
#	"${FILESDIR}/chromium-unbundle-zlib-r1.patch"
	"${FILESDIR}/chromium-77-system-icu.patch"
	"${FILESDIR}/chromium-78-protobuf-export.patch"
	"${FILESDIR}/chromium-79-gcc-alignas.patch"
	"${FILESDIR}/chromium-80-unbundle-libxml.patch"
	"${FILESDIR}/chromium-80-include.patch"
	"${FILESDIR}/chromium-80-gcc-quiche.patch"
	"${FILESDIR}/chromium-80-gcc-permissive.patch"
	"${FILESDIR}/chromium-80-gcc-blink.patch"
	"${FILESDIR}/chromium-80-gcc-abstract.patch"
	"${FILESDIR}/chromium-80-gcc-incomplete-type.patch"

	"${FILESDIR}/relic-intrin.patch"
	"${FILESDIR}/brave-content_settings-redirect.patch"
	"${FILESDIR}/brave-misc.patch"
)

pre_build_checks() {
	# check build requirements.
	CHECKREQS_MEMORY="8G"
	CHECKREQS_DISK_BUILD="100G"
	check-reqs_pkg_setup
}

pkg_pretend() {
	pre_build_checks
}

pkg_setup() {
	pre_build_checks
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	python_setup

	# npm is used to fetch the brave base portion of the source.
	# note that the download is very big, around 19 GB.
	npm install || die
	npm run init || die
	#npm run sync -- --all --run_hooks --run_sync || npm run init || die

	# ... and the patches
	sed -i -e "/\/\/chrome\/installer\/linux/d" src/brave/BUILD.gn || die
	cd src
	default
}

src_configure() {
	python_setup

	local myconf_gn=""

	# make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX NM

	# use gcc.
	myconf_gn+=" is_clang: false,"
	myconf_gn+=" is_cfi: false,"
	myconf_gn+=" is_debug: false,"

	# use the system toolchain.
	myconf_gn+=" custom_toolchain: \"//build/toolchain/linux/unbundle:default\","
	myconf_gn+=" host_toolchain: \"//build/toolchain/linux/unbundle:default\","

	# component build isn't generally intended for use by end users. It's mostly useful
	# for development and debugging.
	myconf_gn+=" is_component_build: false,"

	myconf_gn+=" use_allocator: $(usex tcmalloc \"tcmalloc\" \"none\"),"

	# nacl will be deprecated soon.
	myconf_gn+=" enable_nacl: false,"

	#myconf_gn+=" system_harfbuzz: true,"

	# explicitly disable ICU data file support for system-icu builds.
	if use system-icu; then
		myconf_gn+=" icu_use_data_file: false,"
	fi

	# XXX work in progress
	# myconf_gn+=" use_jumbo_build: true,"

	# prevent the linker from running out of memory.
	myconf_gn+=" blink_symbol_level: 0,"
	myconf_gn+=" symbol_level: 0,"

	# optional dependencies.
	myconf_gn+=" closure_compile: $(usex closure-compile true false),"
	myconf_gn+=" enable_hangout_services_extension: $(usex hangouts true false),"
	myconf_gn+=" enable_widevine: $(usex widevine true false),"
	myconf_gn+=" use_cups: $(usex cups true false),"
	myconf_gn+=" use_gnome_keyring: $(usex gnome-keyring true false),"
	myconf_gn+=" use_kerberos: $(usex kerberos true false),"
	myconf_gn+=" use_pulseaudio: $(usex pulseaudio true false),"

	myconf_gn+=" fieldtrial_testing_like_official_build: true,"

	# don't use bundled toolchain.
	myconf_gn+=" use_gold: false,"
	myconf_gn+=" use_sysroot: false,"
	myconf_gn+=" linux_use_bundled_binutils: false,"
	myconf_gn+=" use_custom_libcxx: false,"

	# disable forced lld
	myconf_gn+=" use_lld: false,"

	# warnings vary depending on the compiler used, and the version,
	# we don't want the build to fail because of that.
	myconf_gn+=" treat_warnings_as_errors: false,"

	# Disable fatal linker warnings, bug 506268.
	myconf_gn+=" fatal_linker_warnings: false,"

	echo ${myconf_gn}

	# configure brave.
	sed -i -e "s|this.extraGnArgs = {}|this.extraGnArgs = {${myconf_gn}}|" lib/config.js || die

	# make the build verbose.
	sed -i -e "s|this.extraNinjaOpts = \[\]|this.extraNinjaOpts = \['-v'\]|" lib/config.js || die
}

src_compile() {
	python_setup

	# final link uses lots of file descriptors.
	ulimit -n 4096

	npm run build Release || die
}

src_install() {
	local BRAVE_HOME
	BRAVE_HOME="/usr/$(get_libdir)/brave"

	exeinto ${BRAVE_HOME}
	doexe src/out/Release/brave
	dosym ${BRAVE_HOME}/brave /usr/bin/${PN} || die

	insinto ${BRAVE_HOME}
	doins src/out/Release/*.bin
	doins src/out/Release/*.pak
	doins src/out/Release/*.so

	if ! use system-icu; then
		doins src/out/Release/icudtl.dat
	fi

	doins -r src/out/Release/locales
	doins -r src/out/Release/resources

	if [[ -d out/Release/swiftshader ]]; then
		insinto "${BRAVE_HOME}/swiftshader"
		doins src/out/Release/swiftshader/*.so
	fi

	# install icons
	local branding size
	for size in 16 24 32 48 64 128 256 ; do
		case ${size} in
			16|32) branding="brave/app/theme/default_100_percent/brave" ;;
			*) branding="brave/app/theme/brave" ;;
		esac
		newicon -s ${size} "src/${branding}/product_logo_${size}.png" ${PN}.png
	done

	domenu "${FILESDIR}"/${PN}.desktop
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
