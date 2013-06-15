# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs

MYP=${PN}.net-${PV}

DESCRIPTION="Automated astrometric calibration programs and service"
HOMEPAGE="http://astrometry.net/"
SRC_URI="${HOMEPAGE}/downloads/${MYP}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	dev-python/numpy
	media-libs/libpng
	media-libs/netpbm
	sci-astronomy/wcslib
	sci-libs/cfitsio
	sci-libs/gsl
	sys-libs/zlib
	virtual/jpeg
	virtual/pyfits
	x11-libs/cairo"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch \
		"${FILESDIR}"/0.43-as-needed.patch \
		"${FILESDIR}"/0.43-respect-user-flags.patch \
		"${FILESDIR}"/0.43-system-libs.patch
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		RANLIB=$(tc-getRANLIB) \
		AR=$(tc-getAR)
	emake \
		CC=$(tc-getCC) \
		RANLIB=$(tc-getRANLIB) \
		AR=$(tc-getAR) \
		extra
}

src_install() {
	export INSTALL_DIR="${ED}"/usr/astrometry
	emake install
	# remove cfitsio duplicates
	rm ${INSTALL_DIR}/bin/{fitscopy,imcopy,listhead} || die

	# remove license file
	rm ${INSTALL_DIR}/doc/LICENSE || die
	dodoc ${INSTALL_DIR}/doc/*
	rm -r ${INSTALL_DIR}/doc || die
	if use examples; then
		mv ${INSTALL_DIR}/examples "${ED}"/usr/share/doc/${PF} || die
	else
		rm -r ${INSTALL_DIR}/examples
	fi
}
