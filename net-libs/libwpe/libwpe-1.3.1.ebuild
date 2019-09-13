# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs cmake-utils

DESCRIPTION="General-purpose library specifically developed for the WPE-flavored port of WebKit."
HOMEPAGE="https://github.com/WebPlatformForEmbedded/libwpe"
SRC_URI="https://github.com/WebPlatformForEmbedded/libwpe/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libxkbcommon
	media-libs/mesa[egl]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"