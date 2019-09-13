# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools bash-completion-r1 linux-info

DESCRIPTION="Unprivileged sandboxing tool, namespaces-powered chroot-like solution"
HOMEPAGE="https://github.com/projectatomic/bubblewrap"
SRC_URI="https://github.com/projectatomic/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="selinux +suid"

DEPEND="
	dev-libs/libxslt
	sys-libs/libseccomp
	sys-libs/libcap
	selinux? ( >=sys-libs/libselinux-2.1.9 )
"
# FIXME: we don't need bashcomp righ??
RDEPEND="${DEPEND}"
# FIXME: bash comp is not working
# FIXME: test is not working
pkg_setup() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		CONFIG_CHECK="~UTS_NS ~IPC_NS ~USER_NS ~PID_NS ~NET_NS"
		linux-info_pkg_setup
	fi
}
src_prepare() {
	default
	eautoreconf
}

src_configure() {
    local -a myconf
    myconf+=("--enable-man")
    myconf+=("--with-bash-completion-dir=${get_bashcompdir}")
	use selinux || myconf+=("--disable-selinux")
	if use suid; then
		myconf+=("-with-priv-mode=setuid")
	else
		myconf+=("-with-priv-mode=none")
	fi
	econf "${myconf[@]}"
}
