# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit meson gnome2

DESCRIPTION="Dictionary utility for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Dictionary"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1+"
SLOT="0/10" # subslot = suffix of libgdict-1.0.so
IUSE="debug +introspection ipv6"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd amd64-linux ~x86-linux"

COMMON_DEPEND="
	>=dev-libs/glib-2.42:2[dbus]
	x11-libs/cairo:=
	>=x11-libs/gtk+-3.21.1:3
	x11-libs/pango
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gsettings-desktop-schemas
	!<gnome-extra/gnome-utils-3.4
"
# ${PN} was part of gnome-utils before 3.4
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.40
	dev-util/itstool
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"
MESON_BUILD_DIR="${WORKDIR}/${P}_mesonbuild"

src_configure() {
	local emesonargs=(
		-Denable-debug=$(usex debug true false) \
		-Duse_ipv6=$(usex ipv6 true false)

	)
	meson_src_configure
}

src_compile() {
        meson_src_compile
}

src_install() {
	cd "${BUILD_DIR}"
	DESTDIR="${D}" eninja install
}
