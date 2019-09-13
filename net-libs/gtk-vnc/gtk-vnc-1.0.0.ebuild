# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )
GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit vala gnome2 python-any-r1 meson

DESCRIPTION="VNC viewer widget for GTK"
HOMEPAGE="https://wiki.gnome.org/Projects/gtk-vnc"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="+introspection pulseaudio sasl +vala debug"
REQUIRED_USE="
	vala? ( introspection )
"

# libview is used in examples/gvncviewer -- no need
# glib-2.30.1 needed to avoid linking failure due to .la files (bug #399129)
RDEPEND="
	>=dev-libs/glib-2.42.0:2
	>=dev-libs/libgcrypt-1.5.0:0=
	dev-libs/libgpg-error
	>=net-libs/gnutls-3.1.18:0=
	>=x11-libs/cairo-1.2
	x11-libs/libX11
	>=x11-libs/gtk+-3.0.0:3[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-0.9.4:= )
	pulseaudio? ( media-sound/pulseaudio )
	sasl? ( dev-libs/cyrus-sasl )
"
# Keymap databases code is generated with python3; configure picks up $PYTHON exported from python-any-r1_pkg_setup
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5
	dev-util/glib-utils
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	vala? (
		$(vala_depend)
		>=dev-libs/gobject-introspection-0.9.4 )
"
# eautoreconf requires gnome-common

src_configure() {
	local emesonargs=(
		$(usex debug --buildtype=debug --buildtype=plain)
		-Dwith-coroutine="gthread"
		$(meson_use vala with-vala)
		$(meson_use introspection with-vala)
	)
	meson_src_configure
}