# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal virtualx meson

DESCRIPTION="Network-related giomodules for glib"
HOMEPAGE="https://git.gnome.org/browse/glib-networking/"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="+gnome +libproxy smartcard +ssl test"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=dev-libs/glib-2.46.0:2[${MULTILIB_USEDEP}]
	gnome? ( gnome-base/gsettings-desktop-schemas )
	libproxy? ( >=net-libs/libproxy-0.4.11-r1:=[${MULTILIB_USEDEP}] )
	smartcard? (
		>=app-crypt/p11-kit-0.18.4[${MULTILIB_USEDEP}]
		>=net-libs/gnutls-3:=[pkcs11,${MULTILIB_USEDEP}] )
	ssl? (
		app-misc/ca-certificates
		>=net-libs/gnutls-3:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.4
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test? ( sys-apps/dbus[X] )
"
# eautoreconf needs >=sys-devel/autoconf-2.65:2.5

src_configure() {
        local emesonargs=(
		-Dlibproxy_support=$(usex libproxy true false)
		-Dgnome_proxy_support=$(usex gnome true false)
		-Dpkcs11_support=$(usex smartcard true false)
		-Dinstalled_tests=$(usex test true false)
		-Dstatic_modules=false
        )
        meson_src_configure
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst

	multilib_pkg_postinst() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	multilib_foreach_abi multilib_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm

	multilib_pkg_postrm() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	multilib_foreach_abi multilib_pkg_postrm
}
