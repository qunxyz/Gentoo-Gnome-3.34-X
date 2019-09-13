# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
#GNOME2_EAUTORECONF="yes"

inherit flag-o-matic gnome2 virtualx multilib-minimal meson

DESCRIPTION="Gimp ToolKit +"
HOMEPAGE="https://www.gtk.org/"
SRC_URI="https://github.com/GNOME/gtk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="4"
IUSE="aqua broadway cloudprint colord cups examples vulkan gtk-doc gstreamer +introspection test vim-syntax wayland +X xinerama"
REQUIRED_USE="
	|| ( aqua wayland X )
	xinerama? ( X )
"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Upstream wants us to do their job:
# https://bugzilla.gnome.org/show_bug.cgi?id=768662#c1
RESTRICT="test"

# FIXME: introspection data is built against system installation of gtk+:3,
# bug #????
COMMON_DEPEND="
	>=dev-libs/atk-2.15[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.53.4:2[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	>=media-libs/libepoxy-1.4[X(+)?,${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.14[aqua?,glib,svg,X?,${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30:2[introspection?,${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.41.0[introspection?,${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-0.9:=
	x11-misc/shared-mime-info

	cloudprint? (
		>=net-libs/rest-0.7[${MULTILIB_USEDEP}]
		>=dev-libs/json-glib-1.0[${MULTILIB_USEDEP}] )
	colord? ( >=x11-misc/colord-0.1.9:0=[${MULTILIB_USEDEP}] )
	cups? ( >=net-print/cups-1.2[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.39:= )
	wayland? (
		>=dev-libs/wayland-1.9.91[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.12
		media-libs/mesa[wayland,${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-0.2[${MULTILIB_USEDEP}]
	)
	X? (
		>=app-accessibility/at-spi2-atk-2.5.3[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.3[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.5[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXfixes[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
		x11-libs/libXdamage[${MULTILIB_USEDEP}]
		xinerama? ( x11-libs/libXinerama[${MULTILIB_USEDEP}] )
	)
	gstreamer? (
		>=media-libs/graphene-1.9.1
	)
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-libs/gobject-introspection-common
	>=dev-util/gdbus-codegen-2.48
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.20
	gtk-doc? ( >=dev-util/gtk-doc-1.20 )
	>=sys-devel/gettext-0.19.7[${MULTILIB_USEDEP}]
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	X? ( x11-base/xorg-proto )
	test? (
		media-fonts/font-misc-misc
		media-fonts/font-cursor-misc )
"
# gtk+-3.2.2 breaks Alt key handling in <=x11-libs/vte-0.30.1:2.90
# gtk+-3.3.18 breaks scrolling in <=x11-libs/vte-0.31.0:2.90
RDEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-update-icon-cache-3
	!<gnome-base/gail-1000
	!<x11-libs/vte-0.31.0:2.90
"
# librsvg for svg icons (PDEPEND to avoid circular dep), bug #547710
PDEPEND="
	gnome-base/librsvg[${MULTILIB_USEDEP}]
	>=x11-themes/adwaita-icon-theme-3.14
	vim-syntax? ( app-vim/gtk-syntax )
"

S="${WORKDIR}/gtk-${PV}"

meson_feature_yes() {
	usex "$1" "-D${2-$1}=yes" "-D${2-$1}=no"
}

src_configure() {
    multilib_configure() {
        local emesonargs=(
        	# GDK backends
        	$(meson_use X x11-backend)
        	$(meson_use wayland wayland-backend)
        	$(meson_use broadway broadway-backend)
        	$(meson_use aqua quartz-backend)

        	# Media backends
        	$(usex gstreamer "-Dgstreamer='gstreamer'" "-Dgstreamer='none'")

        	# Optional dependencies
        	$(meson_feature_yes vulkan)
        	$(meson_feature_yes xinerama)
        	-Dcloudproviders='false'

        	# Print backends
        	$(usex cups "-Dprint-backends='cups,file'" "-Dprint-backends='none'")
        	$(meson_feature_yes colord)

        	# Documentation and introspection
        	$(meson_use gtk-doc documentation)
        	$(meson_use gtk-doc man-pages)
        	$(meson_use introspection)

        	# Demos and binaries
        	$(meson_use examples demos)
        	$(meson_use examples build-examples)
        	$(meson_use test build-tests)
        	$(meson_use test install-tests)
        )
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
