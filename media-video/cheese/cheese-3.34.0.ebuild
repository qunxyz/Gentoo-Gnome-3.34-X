# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 vala virtualx meson

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="https://wiki.gnome.org/Apps/Cheese"

LICENSE="GPL-2+"
SLOT="0/8" # subslot = libcheese soname version
IUSE="+introspection doc test debug"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.39.90:2
	>=x11-libs/gtk+-3.13.4:3[introspection?]
	>=gnome-base/gnome-desktop-2.91.6:3=
	>=media-libs/libcanberra-0.26[gtk3]
	>=media-libs/clutter-1.13.2:1.0[introspection?]
	>=media-libs/clutter-gtk-0.91.8:1.0
	media-libs/clutter-gst:3.0
	media-libs/cogl:1.0=[introspection?]

	media-video/gnome-video-effects
	x11-libs/gdk-pixbuf:2[jpeg,introspection?]
	x11-libs/libX11
	x11-libs/libXtst

	>=media-libs/gstreamer-1.4:1.0[introspection?]
	>=media-libs/gst-plugins-base-1.4:1.0[introspection?,ogg,pango,theora,vorbis,X]

	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-bad-1.4:1.0
	>=media-libs/gst-plugins-good-1.4:1.0

	>=media-plugins/gst-plugins-jpeg-1.4:1.0
	>=media-plugins/gst-plugins-v4l2-1.4:1.0
	>=media-plugins/gst-plugins-vpx-1.4:1.0
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/docbook-xml-dtd:4.3
	app-text/yelp-tools
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.50
	dev-util/itstool
	virtual/pkgconfig
	x11-base/xorg-proto
	test? ( dev-libs/glib:2[utils] )
"

src_prepare() {
	default
	addwrite /dev/dri/renderD129
	addwrite /dev/dri/card0
	addwrite /dev/dri/card1
}

src_configure() {
	local emesonargs=(
		$(usex debug --buildtype=debug --buildtype=plain)
		$(meson_use test tests)
		$(meson_use introspection)
		$(meson_use doc gtk_doc)
		$(meson_use doc man)
	)
	meson_src_configure
}