# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cmake-utils fortran-2 versionator

MAJOR_PV=$(get_version_component_range 1-2)

DESCRIPTION="Utilities for processing and plotting neutron scattering data"
HOMEPAGE="http://www.mantidproject.org/"
SRC_URI="http://download.mantidproject.org/download.psp?f=kits/mantid/Python27/${MAJOR_PV}/${P}-Source.tar.gz"

LICENSE="GPL-3+"

SLOT="0"

KEYWORDS="~amd64"

IUSE="test doxygen opencl shared-libs tcmalloc paraview opencascade"

RDEPEND="dev-lang/python:2.7
sci-libs/nexus
dev-libs/poco
dev-libs/boost[python]
opencl? ( virtual/opencl )
tcmalloc? ( dev-util/google-perftools )
paraview? ( >=sci-visualization/paraview-3.98.1 )
virtual/opengl
x11-libs/qscintilla
x11-libs/qwt
x11-libs/qwtplot3d
dev-python/pyqwt
sci-libs/gsl
dev-python/numpy
dev-cpp/muParser
opencascade? ( sci-libs/opencascade )
dev-python/sphinx
"

DEPEND="${RDEPEND}
doxygen? ( app-doc/doxygen )
test? ( dev-util/cppcheck )"

S=${WORKDIR}/${P}-Source

S="${WORKDIR}/${P}-Source"
BUILD_DIR="${WORKDIR}/${P}-Build"

src_prepare() {
	epatch "${S}/Framework/Geometry/CMakeLists.txt" "${FILESDIR}/limits.patch"
	epatch "${S}/Build/CMake/FindOpenCascade.cmake" "${FILESDIR}/find-opencascade.patch"
	epatch "${S}/MantidPlot/src/zlib123/minigzip.c" "${FILESDIR}/gzip-of.patch"
}

src_configure() {
	cmake-utils_src_configure $(cmake-utils_use opencl OPENCL_BUILD) $(cmake-utils_use_build shared-libs SHARED_LIBS) $(cmake-utils_use_use tcmalloc TCMALLOC) $(cmake-utils_use paraview MAKE_VATES) $(cmake-utils_use_no opencascade OPENCASCADE)
}