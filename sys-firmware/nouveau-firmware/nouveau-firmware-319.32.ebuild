EAPI=5

inherit unpacker

NV_URI="http://us.download.nvidia.com/XFree86/"

DESCRIPTION="Kernel and mesa firmware for video acceleration on nouveau."
HOMEPAGE="http://nouveau.freedesktop.org/wiki/VideoAcceleration/"
SRC_URI="
https://raw.github.com/imirkin/re-vp2/e395c76f787a3356dffbb50192fc5145eba11392/extract_firmware.py
${NV_URI}Linux-x86/319.32/NVIDIA-Linux-x86-319.32.run
"

LICENSE="MIT NVIDIA-r1"
SLOT="0"
KEYWORDS="x86 amd64 ppc ppc64"
DEPEND="<dev-lang/python-3"
RESTRICT="bindist mirror strip"

S=${WORKDIR}/

src_unpack() {
	mkdir "${S}"/NVIDIA-Linux-x86-319.32
	cd "${S}"/NVIDIA-Linux-x86-319.32
	unpack_makeself NVIDIA-Linux-x86-319.32.run
}

src_compile() {
	cd "${S}"
	python2 "${DISTDIR}"/extract_firmware.py
}

src_install() {
	insinto /lib/firmware/nouveau
	doins "${S}"/nv* "${S}"/vuc-*
}
