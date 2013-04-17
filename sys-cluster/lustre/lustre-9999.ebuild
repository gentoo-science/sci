# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.10"

inherit git-2 autotools linux-mod toolchain-funcs udev

DESCRIPTION="Lustre is a parallel distributed file system"
HOMEPAGE="http://wiki.whamcloud.com/"
EGIT_REPO_URI="git://git.whamcloud.com/fs/lustre-release.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+client +utils server +liblustre readline tests tcpd +urandom"

DEPEND="
	virtual/awk
	virtual/linux-sources
	readline? ( sys-libs/readline )
	tcpd? ( sys-apps/tcp-wrappers )
	server? (
		>=sys-kernel/spl-0.6.1
		>=sys-fs/zfs-kmod-0.6.1
		sys-fs/zfs
	)
	"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0001-LU-2982-build-make-AC-check-for-linux-arch-sandbox-f.patch"
	"${FILESDIR}/0002-LU-1812-kernel-3.0-SuSE-and-3.6-FC18-server-patches.patch"
	"${FILESDIR}/0003-LU-2686-kernel-sock_map_fd-replaced-by-sock_alloc_fi.patch"
	"${FILESDIR}/0004-LU-2686-kernel-Kernel-update-for-3.7.2-201.fc18.patch"
	"${FILESDIR}/0005-LU-2850-compat-posix_acl_-to-from-_xattr-take-user_n.patch"
	"${FILESDIR}/0006-LU-2800-llite-introduce-local-getname.patch"
	"${FILESDIR}/0007-LU-2987-llite-rcu-free-inode.patch"
	"${FILESDIR}/0008-LU-2850-kernel-3.8-upstream-removes-vmtruncate.patch"
	"${FILESDIR}/0009-LU-2850-kernel-3.8-upstream-kills-daemonize.patch"
	"${FILESDIR}/0010-LU-3079-kernel-3.9-hlist_for_each_entry-uses-3-args.patch"
	"${FILESDIR}/0011-LU-3079-kernel-f_vfsmnt-replaced-by-f_path.mnt.patch"
	"${FILESDIR}/0012-LU-3117-build-zfs-0.6.1-kmod-dkms-compatibility.patch"
)

pkg_setup() {
	linux-mod_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	epatch ${PATCHES[@]}
	# fix libzfs lib name we have it as libzfs.so.1
	sed -e 's:libzfs.so:libzfs.so.1:g' \
		-e 's:libnvpair.so:libnvpair.so.1:g' \
		-i lustre/utils/mount_utils_zfs.c || die

	# fix some install paths
	sed -e "s:$\(sysconfdir\)/udev:$(get_udevdir):g" \
		-e "s:$\(sysconfdir\)/sysconfig:$\(sysconfdir\)/conf.d:g" \
		-i lustre/conf/Makefile.am || die

	# replace upstream autogen.sh by our src_prepare()
	local DIRS="libcfs lnet lustre snmp"
	local ACLOCAL_FLAGS
	for dir in $DIRS ; do
		ACLOCAL_FLAGS="$ACLOCAL_FLAGS -I $dir/autoconf"
	done
	eaclocal -I config $ACLOCAL_FLAGS
	eautoheader
	eautomake
	eautoconf
	# now walk in configure dirs
	einfo "Reconfiguring source in libsysio"
	cd libsysio
	eaclocal
	eautomake
	eautoconf
	cd ..
	einfo "Reconfiguring source in lustre-iokit"
	cd lustre-iokit
	eaclocal
	eautomake
	eautoconf
	cd ..
	einfo "Reconfiguring source in ldiskfs"
	cd ldiskfs
	eaclocal -I config
	eautoheader
	eautomake -W no-portability
	eautoconf
	cd ..
}

src_configure() {
	local myconf
	if use server; then
		SPL_PATH=$(basename $(echo "${EROOT}usr/src/spl-"*)) \
			myconf="${myconf} --with-spl=\"${EROOT}usr/src/${SPL_PATH}\""
		ZFS_PATH=$(basename $(echo "${EROOT}usr/src/zfs-"*)) \
			myconf="${myconf} --with-zfs=\"${EROOT}usr/src/${ZFS_PATH}\""
	fi
	econf \
		${myconf} \
		--without-ldiskfs \
		--disable-ldiskfs-build \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-release="${KV_FULL}" \
		$(use_enable client) \
		$(use_enable utils) \
		$(use_enable server) \
		$(use_enable liblustre) \
		$(use_enable readline) \
		$(use_enable tcpd libwrap) \
		$(use_enable urandom) \
		$(use_enable tests)
}

src_compile() {
	default
}

src_install() {
	default
}
