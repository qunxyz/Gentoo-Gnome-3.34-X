# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools systemd

DESCRIPTION="D-Bus service to check the availability of dual-GPU"
HOMEPAGE="https://github.com/hadess/switcheroo-control"
SRC_URI="https://github.com/hadess/switcheroo-control/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+systemd"

RDEPEND="
	virtual/libgudev
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}
"

src_prepare() {
	eapply_user
	eautoreconf
}

src_install() {
	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
		emake DESTDIR="${D}" install
	fi
	einstalldocs
	systemd_enable_service basic.target switcheroo-control.service
}
