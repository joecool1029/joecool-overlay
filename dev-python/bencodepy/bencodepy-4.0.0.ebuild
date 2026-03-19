# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} pypy3 )

inherit distutils-r1

MY_PN="bencode.py"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple bencode parser (for Python 2, Python 3 and PyPy)"
HOMEPAGE="https://github.com/fuzeman/bencode.py"
SRC_URI="https://github.com/fuzeman/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BitTorrent-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
