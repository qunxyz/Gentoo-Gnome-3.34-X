# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 multilib-minimal autotools virtualx

DESCRIPTION="C++ interface for GTK+"
HOMEPAGE="https://www.gtkmm.org"
SRC_URI="https://github.com/GNOME/gtkmm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="4.0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc examples test aqua wayland X"
REQUIRED_USE="|| ( aqua wayland X )"

RDEPEND="
	dev-cpp/glibmm:2.62[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.96.0:4[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.28:2[${MULTILIB_USEDEP}]
	dev-cpp/atkmm:2.30[${MULTILIB_USEDEP}]
	>=dev-cpp/cairomm-1.15.0[${MULTILIB_USEDEP}]
	dev-cpp/pangomm:2.44[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.3.2:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	doc? (
		media-gfx/graphviz
		dev-libs/libxslt
		app-doc/doxygen
	)
"

src_prepare() {
	mm-common-prepare --copy --force "${S}"
	autoreconf --force --install --verbose --warnings=all "${S}"
	default
	gnome2_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	#ECONF_SOURCE="${S}" 
	gnome2_src_configure \
		--enable-api-atkmm \
		$(multilib_native_use_enable doc documentation) \
		$(use_enable aqua quartz-backend) \
		$(use_enable wayland wayland-backend) \
		$(use_enable X x11-backend)
}

multilib_src_test() {
	virtx emake check
}

multilib_src_compile() {
	cd gdk/src && make
	cd ../..
	cd gtk/src && make
	cd ../..
	gnome2_src_compile
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	einstalldocs
}
