# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal toolchain-funcs meson

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="http://www.pango.org/"

LICENSE="LGPL-2+ FTL"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="X +introspection doc"

RDEPEND="
	>=media-libs/harfbuzz-1.4.2:=[glib(+),truetype(+),${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.12.92:1.0=[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4:=[X?,${MULTILIB_USEDEP}]
	>=dev-libs/fribidi-0.19.7[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	X? (
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-2.3.1-r1[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.20
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	X? ( x11-base/xorg-proto )
	!<=sys-devel/autoconf-2.63:2.5
"

src_configure() {
    multilib_configure() {
        local emesonargs=(
		$(meson_use doc enable_docs)
		$(meson_use introspection gir)
	)

    meson_src_configure
	if multilib_is_native_abi; then
		ln -s "${S}"/docs/html docs/html || die
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
