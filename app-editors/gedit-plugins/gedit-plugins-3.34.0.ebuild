# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{5,6,7} )
PYTHON_REQ_USE="xml"
VALA_MIN_API_VERSION="0.28"

inherit eutils gnome2 multilib python-single-r1 vala meson

DESCRIPTION="Official plugins for gedit"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit/ShippedPlugins"

LICENSE="GPL-2+"
KEYWORDS="amd64 x86"
SLOT="0"

IUSE_plugins="bookmarks bracketcompletion charmap codecomment colorpicker colorschemer commander drawspaces findinfiles git joinlines multiedit sessionsaver smartspaces terminal textsize translate wordcompletion zeitgeist"
IUSE="debug ${IUSE_plugins}"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	>=app-editors/gedit-3.16
	>=dev-libs/glib-2.32:2
	>=dev-libs/libpeas-1.7.0[gtk]
	>=x11-libs/gtk+-3.9:3
	>=x11-libs/gtksourceview-3.21.3:3.0

	${PYTHON_DEPS}
	>=app-editors/gedit-3.16[introspection,python,${PYTHON_USEDEP}]
	dev-libs/libpeas[python,${PYTHON_USEDEP}]
	>=dev-python/dbus-python-0.82[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	>=x11-libs/gtk+-3.9:3[introspection]
	>=x11-libs/gtksourceview-3.14:3.0[introspection]
	x11-libs/pango[introspection]
	x11-libs/gdk-pixbuf:2[introspection]

	charmap? ( >=gnome-extra/gucharmap-3:2.90[introspection] )
	git? ( >=dev-libs/libgit2-glib-0.0.6 )
	terminal? ( x11-libs/vte:2.91[introspection] )
	$(vala_depend)
	zeitgeist? ( >=gnome-extra/zeitgeist-0.9.12[introspection] )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && python-single-r1_pkg_setup
}

src_prepare() {
	default
}

src_configure() {
	local emesonargs=(
		$(usex debug --buildtype=debug --buildtype=plain)
		$(meson_use bookmarks plugin_bookmarks)
		$(meson_use bracketcompletion plugin_bracketcompletion)
		$(meson_use charmap plugin_charmap)
		$(meson_use codecomment plugin_codecomment)
		$(meson_use colorpicker plugin_colorpicker)
		$(meson_use colorschemer plugin_colorschemer)
		$(meson_use commander plugin_commander)
		$(meson_use drawspaces plugin_drawspaces)
		$(meson_use findinfiles plugin_findinfiles)
		$(meson_use git plugin_git)
		$(meson_use joinlines plugin_joinlines)
		$(meson_use multiedit plugin_multiedit)
		$(meson_use sessionsaver plugin_sessionsaver)
		$(meson_use smartspaces plugin_smartspaces)
		$(meson_use terminal plugin_terminal)
		$(meson_use textsize plugin_textsize)
		$(meson_use translate plugin_translate)
		$(meson_use wordcompletion plugin_wordcompletion)
		$(meson_use zeitgeist plugin_zeitgeist)
	)
	meson_src_configure
}