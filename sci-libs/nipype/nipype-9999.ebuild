# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# pyamg missing py3 support
# PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_4} )
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 git-r3

DESCRIPTION="Neuroimaging in Python: Pipelines and Interfaces"
HOMEPAGE="http://nipy.sourceforge.net/nipype/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nipy/nipype"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/prov[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/pydotplus[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]
	dev-python/traits[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	"

python_test() {
	nosetests -v || die
}
