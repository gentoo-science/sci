# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils texlive-common

DESCRIPTION="Field-theory motivated computer algebra system"
HOMEPAGE="http://cadabra.phi-sci.com"
SRC_URI="http://cadabra.phi-sci.com/${P}.tar.gz"
#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples X"

DEPEND="
	sci-libs/modglue
	sci-mathematics/lie
	dev-libs/gmp[cxx]
	dev-libs/libpcre
	X? (
		x11-libs/gtk+:2
		dev-cpp/gtkmm:2.4
		dev-cpp/pangomm:1.4
		app-text/dvipng )
	doc? ( app-doc/doxygen
		|| ( app-text/texlive-core dev-tex/pdftex ) )"
RDEPEND="${DEPEND}
	virtual/latex-base
	dev-tex/mh"

src_prepare(){
	# xcadabra doesn't respect LDFLAGS (cadabra does!)
	epatch "${FILESDIR}/${PN}-1.25-xcadabra-flags.patch"
}

src_configure(){
	econf $(use_enable X gui)
}

src_compile() {
	emake

	if use doc; then
		cd "${S}/doc"
		emake
		cd doxygen/latex
		emake pdf
	fi
}

src_install() {
	emake DESTDIR="${D}" DEVDESTDIR="${D}" install

	dodoc AUTHORS ChangeLog INSTALL

	if use doc;	then
		cd "${S}/doc/doxygen"
		dohtml html/*
		dodoc latex/*.pdf
	fi

	if use examples; then
		dodoc -r "${S}/examples/"
	fi

	rm -rf "${D}/usr/share/TeXmacs" || die
}

pkg_postinst() {
	etexmf-update
	elog "This version of the cadabra ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id= 194393"
}

pkg_postrm() {
	etexmf-update
}
