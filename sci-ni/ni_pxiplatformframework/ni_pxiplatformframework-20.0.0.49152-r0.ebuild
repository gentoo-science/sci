# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI PXI Platform Framework (metapackage)"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-pxiplatformframework-20.0.0.49152-0+f0.noarch.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
>=sci-ni/libnipxigp15-20.0.0
>=sci-ni/libnipxirm1-20.0.0
>=sci-ni/ni_dim-20.0.0
>=sci-ni/ni_pxipf_errors-19.5.0
>=sci-ni/ni_pxipf_nipxifp_dkms-20.0.0
>=sci-ni/ni_pxipf_nipxirm_bin-20.0.0
>=sci-ni/ni_pxiplatformframework_data-20.0.0.49152
"
