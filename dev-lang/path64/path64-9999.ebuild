# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
CMAKE_VERBOSE=1
if [ "${PV%9999}" != "${PV}" ] ; then
	SCM=git-2
	EGIT_REPO_URI="git://github.com/pathscale/${PN}-suite.git"
	PATH64_URI="compiler assembler"
	PATHSCALE_URI="compiler-rt libcxxrt libdwarf-bsd libunwind stdcxx"
	DBG_URI="git://github.com/path64/debugger.git"
fi

inherit cmake-utils ${SCM} multilib toolchain-funcs

DESCRIPTION="Path64 Compiler Suite Community Edition"
HOMEPAGE="http://www.pathscale.com/ekopath-compiler-suite"
if [ "${PV%9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	SRC_URI=""  # for tarballs
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="assembler custom-cflags debugger fortran +native +openmp valgrind"

DEPEND="!native? ( sys-devel/gcc[vanilla] )
	native? ( || ( dev-lang/ekopath dev-lang/path64 ) )
	valgrind? ( dev-util/valgrind )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use custom-cflags ; then
		ewarn "You are trying to build ${PN} with custom-cflags"
		ewarn "There is a high chance that you will utterly fail!"
		ewarn "Unless you know what you are doing you'd better stop now"
		ewarn "Should you decide to proceed, you are on your own..."
		epause
	fi
}

src_unpack() {
	git-2_src_unpack
	cd "${S}"
	mkdir compiler
	for f in ${PATH64_URI}; do
		EGIT_REPO_URI="git://github.com/${PN}/${f}.git" \
		EGIT_DIR="${EGIT_STORE_DIR}/compiler/${f}" \
		EGIT_SOURCEDIR="${WORKDIR}/${P}/compiler/${f}" git-2_src_unpack
	done
	for f in ${PATHSCALE_URI}; do
		EGIT_REPO_URI="git://github.com/pathscale/${f}.git" \
		EGIT_DIR="${EGIT_STORE_DIR}/compiler/${f}" \
		EGIT_SOURCEDIR="${WORKDIR}/${P}/compiler/${f}" git-2_src_unpack
	done
	EGIT_REPO_URI=${DBG_URI} EGIT_DIR="${EGIT_STORE_DIR}/compiler/pathdb" \
		EGIT_SOURCEDIR="${WORKDIR}/${P}/compiler/pathdb" git-2_src_unpack
}

src_prepare() {
	local ver=$(grep 'SET(PSC_FULL_VERSION' CMakeLists.txt | cut -d'"' -f2)
	cat > "98${PN}" <<-EOF
		PATH=/usr/$(get_libdir)/${PN}/bin
		ROOTPATH=/usr/$(get_libdir)/${PN}/bin
		LDPATH=/usr/$(get_libdir)/${PN}/lib:/usr/$(get_libdir)/${PN}/lib/${ver}/x8664/64
	EOF
	sed -i -e "s/-Wl,-s //" CMakeLists.txt || die #strip
}

src_configure() {
	local linker=$($(tc-getCC) --help -v 2>&1 >/dev/null | \
		sed -n -e '/dynamic-linker/s:.* -dynamic-linker \([^ ]\+\) .*:\1:p')
	local libgcc=$($(tc-getCC) -print-libgcc-file-name)
	use custom-cflags && flags=(
			-DCMAKE_C_FLAGS="${CFLAGS}"
			-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		)

	# Yup, I know how bad it is, but I'd rather have a working compiler
	unset FC F90 F77 FCFLAGS F90FLAGS FFLAGS CFLAGS CXXFLAGS

	if use native ; then
		export CMAKE_BUILD_TYPE=Release
		export CC=pathcc
		export CXX=pathCC
		export MYCMAKEARGS="-UCMAKE_USER_MAKE_RULES_OVERRIDE"
	else
		export CMAKE_BUILD_TYPE=Debug
	fi
	mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr/$(get_libdir)/${PN}
		-DPATH64_ENABLE_TARGETS="x86_64"
		-DPATH64_ENABLE_PROFILING=ON
		-DPATH64_ENABLE_MATHLIBS=ON
		-DPATH64_ENABLE_PATHOPT2=OFF
		$(cmake-utils_use assembler PATH64_ENABLE_PATHAS)
		$(cmake-utils_use assembler PATH64_ENABLE_DEFAULT_PATHAS)
		$(cmake-utils_use fortran PATH64_ENABLE_FORTRAN)
		$(cmake-utils_use openmp PATH64_ENABLE_OPENMP)
		$(cmake-utils_use debugger PATH64_ENABLE_PATHDB)
		$(cmake-utils_use valgrind PATH64_ENABLE_VALGRIND)
		-DPSC_CRT_PATH_x86_64=/usr/$(get_libdir)
		-DPSC_CRTBEGIN_PATH=$(dirname ${libgcc})
		-DPSC_DYNAMIC_LINKER_x86_64=${linker}
		-DCMAKE_C_COMPILER="$(tc-getCC)"
		-DCMAKE_CXX_COMPILER="$(tc-getCXX)"
		"${flags[@]}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doenvd "98${PN}"
}
