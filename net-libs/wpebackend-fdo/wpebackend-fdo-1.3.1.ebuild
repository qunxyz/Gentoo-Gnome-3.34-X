# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs cmake-utils

DESCRIPTION="The WPEBackend-fdo library"
HOMEPAGE="https://github.com/Igalia/WPEBackend-fdo"
SRC_URI="https://github.com/Igalia/WPEBackend-fdo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libxkbcommon
	dev-libs/wayland
	dev-libs/glib
	net-libs/libwpe
	media-libs/mesa[egl]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/WPEBackend-fdo-${PV}"