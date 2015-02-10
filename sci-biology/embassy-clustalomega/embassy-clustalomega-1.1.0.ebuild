# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EBO_DESCRIPTION="Clustal Omega - Scalable multiple protein sequences alignment"

inherit emboss-r1

KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"

RDEPEND+=" sci-biology/clustal-omega"
