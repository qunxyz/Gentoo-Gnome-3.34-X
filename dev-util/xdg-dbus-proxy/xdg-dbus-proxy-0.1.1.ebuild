# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_EAUTORECONF=yes 
inherit autotools toolchain-funcs gnome2

DESCRIPTION="xdg-dbus-proxy is a filtering proxy for D-Bus connections. It was originally part of the flatpak project."
HOMEPAGE="https://github.com/flatpak/xdg-dbus-proxy"
SRC_URI="https://github.com/flatpak/xdg-dbus-proxy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40"
DEPEND="${RDEPEND}
	virtual/pkgconfig"