# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

# pyamg missing py3 support
# PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Neuroimaging in Python: Pipelines and Interfaces"
HOMEPAGE="http://nipy.sourceforge.net/nipype/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nipy/nipype"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="fsl spm afni"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	fsl? ( sci-biology/fsl )
	spm? ( sci-biology/spm )
	afni? ( sci-biology/afni )"
RDEPEND="
	dev-lang/python[sqlite]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/traits[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/pygraphviz[${PYTHON_USEDEP}]"

python_test() {
	nosetests -v || die
}
