# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module

DESCRIPTION="Bioinformatics tools incl. Variant Effect Predictor (VEP)"
HOMEPAGE="http://www.ensembl.org/info/docs/tools/vep/script
	http://www.ensembl.org/info/docs/tools/vep/script/vep_plugins.html"
SRC_URI="https://github.com/Ensembl/ensembl-tools/archive/release/${PV}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="" # BUG: needs Bio::EnsEMBL::Registry
IUSE=""

DEPEND="dev-perl/File-Copy-Recursive
	dev-perl/Archive-Extract"
#DEPEND="dev-perl/Perl-XS
#	dev-perl/Bio-DB-HTS"
RDEPEND="${DEPEND}"

S="${WORKDIR}/ensembl-tools-release-${PV}"

src_install(){
	perl_set_version
	insinto ${VENDOR_LIB}/${PN}
	cd scripts/variant_effect_predictor || die
	# FIXME: INSTALL.pl does not exit upon error
	./INSTALL.pl --DESTDIR="${DESTDIR}"/"${EPREFIX}" --AUTO=ac || die
	newdoc README.txt variant_effect_predictor.txt
	cd ../../scripts/region_reporter || die
	dobin *.pl
	newdoc README.txt region_reporter.txt
	cd ../../scripts/assembly_converter
	dobin *.pl
	insinto /usr/share/"${PN}"/examples
	doins assemblymapper.in
	#insinto ${VENDOR_LIB}/${PN}
	#doins *.pm
	newdoc README.txt assembly_converter.txt
	insinto /usr/share/"${PN}"/examples
	doins assemblymapper.in
	cd ../../scripts/id_history_converter
	dobin *.pl
	newdoc README.txt id_history_converter.txt
	insinto /usr/share/"${PN}"/examples
	doins idmapper.in
}
