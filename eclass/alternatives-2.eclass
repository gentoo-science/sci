# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Based in part upon 'alternatives.exlib' from Exherbo, which is:
# Copyright 2008, 2009 Bo Ørsted Andresen
# Copyright 2008, 2009 Mike Kelly
# Copyright 2009 David Leverton

# @ECLASS: alternatives-2
# @MAINTAINER:
# Gentoo Science Project <sci@gentoo.org>
# @BLURB: Manage alternative implementations.
# @DESCRIPTION:
# Autogenerate eselect modules for alternatives and ensure that valid provider
# is set.
#
# Remove eselect modules when last provider is unmerged.
#
# If your package provides pkg_postinst or pkg_prerm phases, you need to be
# sure you explicitly run alternatives-2_pkg_{postinst,prerm} where appropriate.

case "${EAPI:-0}" in
	0|1|2|3|4)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	5)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

DEPEND=">=app-admin/eselect-1.4.4-r102"
RDEPEND="${DEPEND}
	!app-admin/eselect-blas
	!app-admin/eselect-cblas
	!app-admin/eselect-lapack"

# @ECLASS-VARIABLE: ALTERNATIVES_DIR
# @INTERNAL
# @DESCRIPTION:
# Alternatives directory with symlinks managed by eselect.
ALTERNATIVES_DIR="/etc/env.d/alternatives"

# @FUNCTION: alternatives_for
# @USAGE: <alternative> <provider> <importance> <source> <target> [<source> <target> [...]]
# @DESCRIPTION:
# Set up alternative provider.
#
# EXAMPLE:
# @CODE
# alternatives_for sh bash 0 \
#     /usr/bin/sh bash
# @CODE
alternatives_for() {
	debug-print-function ${FUNCNAME} "${@}"

	dodir /etc/env.d/alternatives

	ALTERNATIVESDIR_ROOTLESS="${ED}/etc/env.d/alternatives" \
		eselect alternatives add ${@} || die

	ALTERNATIVES_CREATED+=( ${1} )
}

# @FUNCTION: cleanup_old_alternatives_module
# @USAGE: <alternative>
# @DESCRIPTION:
# Remove old alternatives module.
cleanup_old_alternatives_module() {
	debug-print-function ${FUNCNAME} "${@}"

	local alt=${1} old_module="${EROOT%/}/usr/share/eselect/modules/${alt}.eselect"

	if [[ -f "${old_module}" && $(grep 'ALTERNATIVE=' "${old_module}" | cut -d '=' -f 2) == "${alt}" ]]; then
		local version="$(grep 'VERSION=' "${old_module}" | grep -o '[0-9.]\+')"
		if [[ "${version}" == "0.1" || "${version}" == "20080924" ]]; then
			einfo "rm ${old_module}"
			rm "${old_module}" || eerror "rm ${old_module} failed"
		fi
	fi
}

# @FUNCTION: alternatives-2_pkg_postinst
# @DESCRIPTION:
# Create eselect modules for all provided alternatives if necessary and ensure
# that valid provider is set.
#
# Also remove old eselect modules for provided alternatives.
#
# Provided alternatives are set up using alternatives_for().
alternatives-2_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"

	local alt

	for alt in ${ALTERNATIVES_CREATED[@]}; do
		if ! eselect ${alt} show > /dev/null; then
			einfo "Creating Alternative for ${alt}"
			eselect alternatives create ${alt}
		fi

		# Set alternative provider if there is no valid provider selected
		eselect "${alt}" update "${provider}"

		cleanup_old_alternatives_module ${alt}
	done
}

# @FUNCTION: alternatives-2_pkg_prerm
# @DESCRIPTION:
# Ensure a valid provider is set in case the package is unmerged and
# remove autogenerated eselect modules for alternative when last
# provider is unmerged.
#
# Provided alternatives are set up using alternatives_for().
alternatives-2_pkg_prerm() {
	debug-print-function ${FUNCNAME} "${@}"

	local alt ret

	# If we are uninstalling, update alternatives to valid provider
	[[ -n ${REPLACED_BY_VERSION} ]] || ignore="--ignore"

	for alt in ${ALTERNATIVES_CREATED[@]}; do
		eselect "${alt}" update ${ignore} "${provider}"

		case ${ret} in
			0) : ;;
			2)
				# This was last provider for the alternative, remove eselect module
				einfo "Cleaning up unused alternatives module for ${alt}"
				eselect alternatives delete "${alt}" || eerror "Failed to remove ${alt}"
				;;
			*)
				eerror "eselect ${alt} update ${provider} returned ${ret}"
				;;
		esac
	done
}

EXPORT_FUNCTIONS pkg_postinst pkg_prerm
