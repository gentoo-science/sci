# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Library for static analysis of the numerical variables of a program by Abstract Interpretation"
HOMEPAGE="http://apron.cri.ensmp.fr/library/"
SRC_URI="http://apron.cri.ensmp.fr/library/${P}.tgz"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ocaml"

RDEPEND="ocaml? ( >=dev-lang/ocaml-3.09
				dev-ml/camlidl
				dev-ml/mlgmpidl )
		dev-libs/gmp
		dev-libs/mpfr"
DEPEND="${RDEPEND}
		doc? ( app-text/texlive
				app-text/ghostscript-gpl )"

src_prepare() {
	mv Makefile.config.model Makefile.config

	#fix compile process
	sed -i Makefile.config \
		-e "s/FLAGS = \\\/FLAGS += \\\/g" \
		-e "s/-O3 -DNDEBUG/-DNDEBUG/g" \
		-e "s/APRON_PREFIX =.*/APRON_PREFIX = \${DESTDIR}\/usr/g" \
		-e "s/MLGMPIDL_PREFIX =.*/MLGMPIDL_PREFIX = \${DESTDIR}\/usr/g"

	#fix doc building process
	sed -i Makefile -e "s/; make html/; make/g"
	sed -i apronxx/Makefile \
		-e "s:cd doc/latex && make:cd doc/latex; rubber refman.tex; dvipdf refman.dvi:g"
	sed -i apronxx/doc/Doxyfile \
		-e "s/OUTPUT_DIRECTORY       = \/.*/OUTPUT_DIRECTORY       = .\//g" \
		-e "s/STRIP_FROM_PATH        = \/.*/STRIP_FROM_PATH        = .\//g"

	#fix ppl install for 32 platforms
	sed -i ppl/Makefile -e "s/libap_ppl_caml\*\./libap_ppl\*\./g"

	if [[ "$(gcc-major-version)" == "4" ]]; then
		sed -i -e "s/# HAS_LONG_DOUBLE = 1/HAS_LONG_DOUBLE = 1/g" Makefile.config
	fi
	if use !ocaml; then
		sed -i -e "s/HAS_OCAML = 1/#HAS_OCAML = 0/g" Makefile.config
	fi
}

src_compile() {
	emake -j1 || die "emake failed"
}

src_install(){
	DESTDIR="${D}" emake install || die "emake install failed"
	dodoc AUTHORS Changes README

	if use doc; then
		dodoc apron/apron.pdf
		if use ocaml; then
			dodoc mlapronidl/mlapronidl.pdf
		fi
	fi
}
