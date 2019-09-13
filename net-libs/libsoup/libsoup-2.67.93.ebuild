# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_5,3_6,3_7} )
VALA_USE_DEPEND="vapigen"

inherit gnome2 multilib-minimal meson python-any-r1 vala toolchain-funcs

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="https://wiki.gnome.org/Projects/libsoup"

LICENSE="LGPL-2+"
SLOT="2.4"

IUSE="gnome gssapi samba +introspection vala doc test"
REQUIRED_USE="vala? ( introspection )"

#includes goes into wrong folder with meson?
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=dev-db/sqlite-3.8.2:3[${MULTILIB_USEDEP}]
	>=net-libs/glib-networking-2.38.2[ssl,${MULTILIB_USEDEP}]
	gssapi? ( virtual/krb5[${MULTILIB_USEDEP}] )
	>=dev-libs/gobject-introspection-0.9.5:=
	samba? ( net-fs/samba )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.20
	sys-devel/gettext
	>=net-libs/libpsl-0.20.0[${MULTILIB_USEDEP}]
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}]
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
}

src_configure() {
	multilib_configure() {
		local emesonargs=(
			-Ddefault_library=shared
			-Dtls_check=false
			-Dgssapi=$(usex gssapi enabled disabled)
			-Dvapi=$(usex vala enabled disabled)
			-Dintrospection=$(usex introspection enabled disabled)
			$(meson_use gnome)
			$(meson_use doc)
			$(meson_use test tests)
			$(meson_use samba ntlm_auth '${EPREFIX}'/usr/bin/ntlm_auth)
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
