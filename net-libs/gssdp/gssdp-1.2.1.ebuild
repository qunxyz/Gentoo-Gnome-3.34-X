# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"

inherit gnome2 multilib-minimal vala meson

DESCRIPTION="A GObject-based API for handling resource discovery and announcement over SSDP"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP"

LICENSE="LGPL-2"
SLOT="0/3"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="+introspection gtk"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.44.2:2.4[${MULTILIB_USEDEP},introspection?]
	gtk? ( >=x11-libs/gtk+-3.0:3 )
	introspection? (
		$(vala_depend)
		>=dev-libs/gobject-introspection-1.36:= )
	!<net-libs/gupnp-vala-0.10.3
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

src_prepare() {
 eapply_user
	use introspection && vala_src_prepare
}

src_configure() {
    multilib_configure() {
        local emesonargs=(
		        $(meson_use gtk sniffer)
		        $(meson_use introspection)
		        $(meson_use introspection vapi)
	        )

        meson_src_configure
	    if multilib_is_native_abi; then
		    # fix gtk-doc
		    ln -s "${S}"/doc/html doc/html || die
	    fi
	}
	multilib_foreach_abi multilib_configure
}

src_compile() {
	multilib_foreach_abi meson_src_compile
}

src_install() {
	multilib_foreach_abi meson_src_install
}
