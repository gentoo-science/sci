# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3} )

inherit distutils-r1 git-r3 multilib

DESCRIPTION="A tool to create LaTeX tables from python lists and arrays."
HOMEPAGE="https://code.google.com/p/matrix2latex/"
EGIT_REPO_URI="https://github.com/TheChymera/matrix2latex"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="app-text/texlive"
DEPEND=""

