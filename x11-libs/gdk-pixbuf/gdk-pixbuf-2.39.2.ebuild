# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2 multilib multilib-minimal meson

DESCRIPTION="Image loading library for GTK+"
HOMEPAGE="https://git.gnome.org/browse/gdk-pixbuf"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ~ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="X +introspection jpeg jpeg2k tiff test doc"

# Remove SRC_URI when gnome bug #795069 is fixed
SRC_URI="${SRC_URI} test? ( https://git.gnome.org/browse/gdk-pixbuf/plain/tests/bug753605-atsize.jpg?h=2.36.12 -> ${PN}-2.36.12-bug753605-atsize.jpg )"

COMMON_DEPEND="
	>=dev-libs/glib-2.48.0:2[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.4:0=[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	jpeg? ( virtual/jpeg:0=[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/jasper:=[${MULTILIB_USEDEP}] )
	tiff? ( >=media-libs/tiff-3.9.2:0=[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11[${MULTILIB_USEDEP}] )
"
DEPEND="${COMMON_DEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.20
	>=sys-devel/gettext-0.19
	virtual/pkgconfig
"
# librsvg blocker is for the new pixbuf loader API, you lose icons otherwise
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/gail-1000
	!<gnome-base/librsvg-2.31.0
	!<x11-libs/gtk+-2.21.3:2
	!<x11-libs/gtk+-2.90.4:3
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gdk-pixbuf-query-loaders$(get_exeext)
)

PATCHES=(
	# Do not run lowmem test on uclibc
	# See https://bugzilla.gnome.org/show_bug.cgi?id=756590
	"${FILESDIR}"/${PN}-2.32.3-fix-lowmem-uclibc.patch
)

src_configure() {
    multilib_configure() {
        local emesonargs=(
            -Dx11=$(usex X true false)
            -Dgir=$(usex introspection true false)
            -Djpeg=$(usex jpeg true false)
            -Djasper=$(usex jpeg2k true false)
            -Dtiff=$(usex tiff true false)
            -Dinstalled_tests=$(usex test true false)
            -Ddocs=$(usex doc true false)
            -Dpng=true
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

pkg_preinst() {
	gnome2_pkg_preinst

	multilib_pkg_preinst() {
		# Make sure loaders.cache belongs to gdk-pixbuf alone
		local cache="usr/$(get_libdir)/${PN}-2.0/2.10.0/loaders.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"/${cache} || die
		else
			touch "${ED}"/${cache} || die
		fi
	}

	multilib_foreach_abi multilib_pkg_preinst
}

pkg_postinst() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER

	multilib_foreach_abi gnome2_pkg_postinst

	# Migration snippet for when this was handled by gtk+
	if [ -e "${EROOT}"usr/lib/gtk-2.0/2.*/loaders ]; then
		elog "You need to rebuild ebuilds that installed into" "${EROOT}"usr/lib/gtk-2.0/2.*/loaders
		elog "to do that you can use qfile from portage-utils:"
		elog "emerge -va1 \$(qfile -qC ${EPREFIX}/usr/lib/gtk-2.0/2.*/loaders)"
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		rm -f "${EROOT}"usr/lib*/${PN}-2.0/2.10.0/loaders.cache
	fi
}
