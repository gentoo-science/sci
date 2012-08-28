# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils fortran-2

DESCRIPTION="A package for evaluation of scalar and tensor one-loop integrals"
HOMEPAGE="http://www.feynarts.de/looptools"
SRC_URI="http://www.feynarts.de/looptools/${P}.tar.gz"

LICENSE="LGPL-3"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/fortran"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
	export VER="${PV}"
}
