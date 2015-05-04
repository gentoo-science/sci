# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Additional utilities for Celera assembler (wgs-assembler) from UMD"
HOMEPAGE="http://www.cbcb.umd.edu/software/celera-assembler"
SRC_URI="ftp://ftp.cbcb.umd.edu/pub/software/CAutils.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl"

# is partially included in amos-3.1.0
