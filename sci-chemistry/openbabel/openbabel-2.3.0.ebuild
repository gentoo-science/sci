# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/openbabel/openbabel-2.2.3.ebuild,v 1.11 2010/07/18 14:53:22 armin76 Exp $

EAPI="3"

WX_GTK_VER="2.8"

inherit cmake-utils eutils wxwidgets

DESCRIPTION="Interconverts file formats used in molecular modeling"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="doc wxwidgets"

RDEPEND="
	dev-cpp/eigen:2
	dev-libs/libxml2:2
	!sci-chemistry/babel
	sci-libs/inchi
	sys-libs/zlib
	wxwidgets? ( x11-libs/wxGTK:2.8[X] )"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.8"

DOCS="AUTHORS ChangeLog NEWS README THANKS doc/*.inc doc/README* doc/*.mol2"

src_prepare() {
	epatch "${FILESDIR}"/${P}-test_lib_path.patch
}

src_configure() {
	local mycmakeargs=""
	mycmakeargs="${mycmakeargs}
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		$(cmake-utils_use wxwidgets BUILD_GUI)"

	cmake-utils_src_configure
}

src_install() {
	dohtml doc/{*.html,*.png} || die
	if use doc ; then
		insinto /usr/share/doc/${PF}/API/html
		doins doc/API/html/* || die
	fi
	cmake-utils_src_install
}

src_test() {
	local mycmakeargs=""
	mycmakeargs="${mycmakeargs}
		-DOPENBABEL_USE_SYSTEM_INCHI=ON
		$(cmake-utils_use wxwidgets BUILD_GUI)
		$(cmake-utils_use_enable test TESTS)"

	cmake-utils_src_configure
	cmake-utils_src_compile
	cmake-utils_src_test
}
