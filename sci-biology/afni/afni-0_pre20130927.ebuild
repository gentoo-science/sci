# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib pax-utils toolchain-funcs

DESCRIPTION="An open-source environment for processing and displaying functional MRI data"
HOMEPAGE="http://afni.nimh.nih.gov/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tgz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/motif[-static-libs]
	sci-libs/gsl
	dev-libs/expat
	x11-libs/libXpm
	media-libs/netpbm
	x11-libs/libGLw
	media-libs/qhull
	sys-devel/llvm
	media-video/mpeg-tools
	media-libs/libjpeg-turbo
	x11-libs/libXft "

# x11-libs/motif[static-libs] breaks the build.
# See upstream discussion
# http://afni.nimh.nih.gov/afni/community/board/read.php?1,85348,85348#msg-85348

DEPEND="${RDEPEND}
	app-shells/tcsh"

S=${WORKDIR}/afni_src
BUILD="linux_fedora_19_64"
BIN_CONFLICTS=(qdelaunay whirlgif djpeg cjpeg qhull rbox count mpeg_encode)

src_prepare() {
	cp other_builds/Makefile.${BUILD} Makefile || die "Could not copy Makefile"
	sed -e "s~CC     = /usr/bin/gcc -O2 -m64~CC     = $(tc-getCC) \$(CFLAGS)~" \
		-e "s~CCMIN  = /usr/bin/gcc -m64~CCMIN  = $(tc-getCC) \$(CFLAGS)~" \
		-e "s~LD     = /usr/bin/gcc~LD     = $(tc-getCC)~" \
		-e "s~AR     = /usr/bin/ar~AR     = $(tc-getAR)~" \
		-e "s~RANLIB = /usr/bin/ranlib~RANLIB = $(tc-getRANLIB)~" \
		-i Makefile || die "Could not edit Makefile"
		# they provide somewhat problematic makefiles :(
	sed -e "s~ifeq ($(CC),gcc)~ifeq (1,1)~"\
		-i SUMA/SUMA_Makefile || die "Could not edit SUMA/SUMA_Makefile"
		# upstream checks if $CC is EXACTLY gcc, else sets variables for Mac
}

src_compile() {
	emake -j1 all plugins suma_exec
}

src_install() {
	emake INSTALLDIR="${ED}/usr/bin" -j1 install install_plugins
	emake INSTALLDIR="${ED}/usr/$(get_libdir)" -j1 install_lib
	for CONFLICT in ${BIN_CONFLICTS[@]}; do
		rm "${ED}/usr/bin/${CONFLICT}"
	done
}
