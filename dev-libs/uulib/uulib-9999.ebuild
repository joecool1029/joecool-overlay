# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3
EGIT_REPO_URI="https://github.com/hannob/uudeview.git"

DESCRIPTION="Library that supports Base64 (MIME), uuencode, xxencode and binhex coding"
HOMEPAGE="https://github.com/hannob/uudeview"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
