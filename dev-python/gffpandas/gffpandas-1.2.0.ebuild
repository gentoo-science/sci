# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python library to Filter and sort GFF3 annotations"
HOMEPAGE="https://github.com/foerstner-lab/gffpandas
	https://gffpandas.readthedocs.io/en/latest/"
SRC_URI="https://github.com/foerstner-lab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DEPEND="dev-python/pandas[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""
