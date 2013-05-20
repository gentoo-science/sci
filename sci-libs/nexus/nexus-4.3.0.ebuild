# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

FORTRAN_NEEDED=fortran
PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit eutils fortran-2 java-pkg-opt-2 flag-o-matic python-single-r1

DESCRIPTION="Data format for neutron and x-ray scattering data"
HOMEPAGE="http://nexusformat.org/"
SRC_URI="http://download.nexusformat.org/kits/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="xml doc fortran swig cbflib guile tcl java python"

RDEPEND="${PYTHON_DEPS}
	sci-libs/hdf5
	xml?	( dev-libs/minixml )
	cbflib?	( sci-libs/cbflib )
	guile?	( dev-scheme/guile )
" # N.B. the website says it depends on HDF4 too, but I find it builds fine without it

DEPEND="${RDEPEND}
	doc?	( app-doc/doxygen dev-tex/xcolor )
	swig?	( dev-lang/swig )
"
src_configure() {
	# Linking between Fortran libraries gives a relocation error, using workaround suggested at:
	# http://www.gentoo.org/proj/en/base/amd64/howtos/?part=1&chap=3
	use fortran && append-fflags -fPIC

	econf	$(use_with doc doxygen) \
		$(use_with fortran f90) \
		$(use_with swig) \
		$(use_with xml) \
		$(use_with cbflib) \
		$(use_with guile) \
		$(use_with java) \
		$(use_with python)
}

src_compile() {
	# Handling of dependencies between Fortran module files doesn't play well with parallel make
	use fortran && MAKEOPTS+=" -j1 "
	default
}
