# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI-DMM C Development Support"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-dmm-devel-20.1.0.49152-0+f0.noarch.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
>=sci-ni/ni_dmm_libs-20.1.0
>=sci-ni/ni_icp_devel-19.0.0
"
