# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala meson 

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2+"
SLOT="0"
IUSE="v4l"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

VALA_DEPEND="
	$(vala_depend)
	>=dev-libs/gobject-introspection-0.9.6:=
	dev-libs/folks[vala(+)]
	gnome-base/gnome-desktop:3=[introspection]
	gnome-extra/evolution-data-server[vala]
	net-libs/telepathy-glib[vala]
"
# Configure is wrong; it needs cheese-3.5.91, not 3.3.91
# folks-0.11.4 to avoid build issues with vala-0.36, upstream 7a9001b056b4fb1d00375e7b2adeda9b7cf93c90
RDEPEND="
	>=dev-libs/folks-0.11.4:=[eds,telepathy]
	>=dev-libs/glib-2.37.6:2
	>=dev-libs/libgee-0.10:0.8
	>=gnome-extra/evolution-data-server-3.13.90:=[gnome-online-accounts]
	>=gnome-base/gnome-desktop-3.0:3=
	media-libs/clutter:1.0
	media-libs/clutter-gtk:1.0
	media-libs/libchamplain:0.12
	net-libs/gnome-online-accounts:=[vala]
	>=net-libs/telepathy-glib-0.17.5
	>=sci-geosciences/geocode-glib-3.15.3
	x11-libs/cairo:=
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22.0:3
	>=dev-libs/libhandy-0.0.4
	x11-libs/pango
	v4l? ( >=media-video/cheese-3.5.91:= )
"
DEPEND="${RDEPEND}
	${VALA_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dmanpage=true
		-Dcheese=$(usex v4l true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install 
	rm ${D}/usr/include/libhandy-0.0/hdy-action-row.h
	rm ${D}/usr/include/libhandy-0.0/hdy-arrows.h
	rm ${D}/usr/include/libhandy-0.0/hdy-column.h
	rm ${D}/usr/include/libhandy-0.0/hdy-combo-row.h
	rm ${D}/usr/include/libhandy-0.0/hdy-dialer-button.h
	rm ${D}/usr/include/libhandy-0.0/hdy-dialer-cycle-button.h
	rm ${D}/usr/include/libhandy-0.0/hdy-dialer.h
	rm ${D}/usr/include/libhandy-0.0/hdy-enum-value-object.h
	rm ${D}/usr/include/libhandy-0.0/hdy-enums.h
	rm ${D}/usr/include/libhandy-0.0/hdy-leaflet.h
	rm ${D}/usr/include/libhandy-0.0/hdy-search-bar.h
	rm ${D}/usr/include/libhandy-0.0/hdy-string-utf8.h
	rm ${D}/usr/include/libhandy-0.0/hdy-value-object.h
	rm ${D}/usr/include/libhandy-0.0/hdy-version.h
	rm ${D}/usr/lib64/girepository-1.0/Handy-0.0.typelib
	rm ${D}/usr/lib64/libhandy-0.0.so.0
	rm ${D}/usr/lib64/pkgconfig/libhandy-0.0.pc
	rm ${D}/usr/share/gir-1.0/Handy-0.0.gir
	rm ${D}/usr/share/vala/vapi/libhandy-0.0.deps
	rm ${D}/usr/share/vala/vapi/libhandy-0.0.vapi
	rm ${D}/usr/include/libhandy-0.0/handy.h
	rm ${D}/usr/include/libhandy-0.0/hdy-dialog.h
	rm ${D}/usr/include/libhandy-0.0/hdy-expander-row.h
	rm ${D}/usr/include/libhandy-0.0/hdy-fold.h
	rm ${D}/usr/include/libhandy-0.0/hdy-header-group.h
	rm ${D}/usr/include/libhandy-0.0/hdy-list-box.h
	rm ${D}/usr/include/libhandy-0.0/hdy-main.h
	rm ${D}/usr/include/libhandy-0.0/hdy-title-bar.h
	rm ${D}/usr/lib64/libhandy-0.0.so
	rm ${D}
}
