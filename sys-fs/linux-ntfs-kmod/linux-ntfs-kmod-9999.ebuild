# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Out-of-tree NTFS(NTFS PLUS) kernel module"
HOMEPAGE="https://github.com/namjaejeon/linux-ntfs"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/namjaejeon/linux-ntfs.git"
	EGIT_MIN_CLONE_TYPE="single"
else
	SRC_URI="https://github.com/namjaejeon/linux-ntfs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/linux-ntfs-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"

DOCS=( README.md )

CONFIG_CHECK="!NTFS_FS"
ERROR_NTFS_FS="CONFIG_NTFS_FS is enabled in your kernel: the legacy in-kernel
	NTFS driver exports a module also named 'ntfs' and will conflict with this
	package. Disable CONFIG_NTFS_FS (and rebuild the kernel) before installing."

pkg_setup() {
	linux-mod-r1_pkg_setup

	if kernel_is -lt 6 1; then
		die "This module requires kernel 6.1 or newer"
	fi
}

src_compile() {
	local modlist=( "ntfs=fs/ntfs:::all" )
	local modargs=(
		KDIR="${KV_OUT_DIR}"
	)
	linux-mod-r1_src_compile
}
