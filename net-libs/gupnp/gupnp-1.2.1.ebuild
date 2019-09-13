# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )
PYTHON_REQ_USE="xml"

inherit gnome2 multilib-minimal python-single-r1 vala meson

DESCRIPTION="An object-oriented framework for creating UPnP devs and control points"
HOMEPAGE="https://wiki.gnome.org/Projects/GUPnP"

LICENSE="LGPL-2"
SLOT="0/4"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="connman +introspection kernel_linux networkmanager"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	?? ( connman networkmanager )
"

# prefix: uuid dependency can be adapted to non-linux platforms
RDEPEND="${PYTHON_DEPS}
	>=net-libs/gssdp-1.1:0=[introspection?,${MULTILIB_USEDEP}]
	>=net-libs/libsoup-2.48.0:2.4[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	>=sys-apps/util-linux-2.24.1-r3[${MULTILIB_USEDEP}]
	introspection? (
			>=dev-libs/gobject-introspection-1.36:=
			$(vala_depend) )
	connman? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	networkmanager? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	!net-libs/gupnp-vala
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.14
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

src_prepare() {
	use introspection && vala_src_prepare
	eapply_user
}

src_configure() {
	local backend=unix
	use kernel_linux && backend=linux
	use connman && backend=connman
	use networkmanager && backend=network-manager
	
 multilib_configure() {
    local emesonargs=(
	        -Dcontext_manager=${backend}
	         $(meson_use introspection)
	         $(meson_use introspection vapi)
	         )
	    if multilib_is_native_abi; then
		    ln -s "${S}"/doc/html doc/html || die
	    fi
	    meson_src_configure
	    }
	 multilib_foreach_abi multilib_configure
}

src_compile() {
	multilib_foreach_abi meson_src_compile
}

src_install() {
	multilib_foreach_abi meson_src_install
}
