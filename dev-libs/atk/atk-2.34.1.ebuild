# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2  multilib-minimal meson

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="+introspection doc"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.32.0:= )
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.25
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

src_configure() {
    multilib_configure() {
        local emesonargs=(
        	$(meson_use doc docs)
        	$(meson_use introspection)
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
