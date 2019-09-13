# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 multilib-minimal vala meson

DESCRIPTION="A library full of GTK+ widgets for mobile phones"
HOMEPAGE="https://source.puri.sm/Librem5/libhandy"
SRC_URI="https://source.puri.sm/Librem5/libhandy/-/archive/v${PV}/libhandy-v${PV}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="introspection profile doc tests examples glade"

RDEPEND="
	>=dev-libs/glib-2.53.4:2[${MULTILIB_USEDEP}]
	glade? ( dev-util/glade )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.18
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"
S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	vala_src_prepare
	eapply_user
}

src_configure() {
	local emesonargs=(
		-Dintrospection=$(usex introspection enabled disabled)
		-Dvapi=true
		-Dprofiling=$(usex profile true false)
		-Dgtk_doc=$(usex doc true false)
		-Dtests=$(usex tests true false)
		-Dexamples=$(usex examples true false)
		-Dglade_catalog=$(usex glade enabled disabled)
	)
	meson_src_configure
}
