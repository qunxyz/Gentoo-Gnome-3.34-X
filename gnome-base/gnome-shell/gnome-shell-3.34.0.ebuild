# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{5,6,7} )

inherit autotools gnome2 multilib pax-utils python-r1 systemd meson ninja-utils

DESCRIPTION="Provides core UI functions for the GNOME 3 desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShell"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
IUSE="+bluetooth +networkmanager nsplugin +ibus systemd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86"

COMMON_DEPEND="
	>=dev-util/meson-0.46.1
	>=app-accessibility/at-spi2-atk-2.5.3
	>=dev-libs/atk-2[introspection]
	>=app-crypt/gcr-3.7.5[introspection]
	>=dev-libs/glib-2.58.0:2[dbus]
	>=dev-libs/gjs-1.57.2
	>=dev-libs/gobject-introspection-1.58.0:=
	>=dev-libs/libical-3.0.5-r2
	>=x11-libs/gtk+-3.15.0:3[introspection]
	>=dev-libs/libcroco-0.6.8:0.6
	>=gnome-base/gnome-desktop-3.7.90:3=[introspection]
	>=gnome-base/gsettings-desktop-schemas-3.21.3
	>=gnome-extra/evolution-data-server-3.33.2:=
	>=media-libs/gstreamer-0.11.92:1.0
	>=net-im/telepathy-logger-0.2.4[introspection]
	>=net-libs/telepathy-glib-0.19[introspection]
	>=sys-auth/polkit-0.100[introspection]
	>=x11-libs/libXfixes-5.0
	x11-libs/libXtst
	>=x11-wm/mutter-${PV}[introspection]
	>=x11-libs/startup-notification-0.11
	dev-lang/sassc
	${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-libs/dbus-glib
	dev-libs/libxml2:2
	media-libs/libcanberra[gtk3]
	media-libs/mesa
	>=media-sound/pulseaudio-2
	>=net-libs/libsoup-2.40:2.4[introspection]
	x11-libs/libX11
	x11-libs/gdk-pixbuf:2[introspection]
	x11-apps/mesa-progs
	>=net-wireless/gnome-bluetooth-3.20[introspection]
	networkmanager? (
		app-crypt/libsecret
		>=gnome-extra/nm-applet-0.9.8
		>=net-misc/networkmanager-0.9.8:=[introspection] )
	nsplugin? ( >=dev-libs/json-glib-0.13.2 )
"

RDEPEND="${COMMON_DEPEND}
	app-accessibility/at-spi2-core:2[introspection]
	>=app-accessibility/caribou-0.4.8
	dev-libs/libgweather:2=
	>=sys-apps/accountsservice-0.6.14[introspection]
	>=sys-power/upower-0.99:=[introspection]
	x11-libs/pango[introspection]
	>=gnome-base/gnome-session-3.30.0
	>=gnome-base/gnome-settings-daemon-3.30.0
	>=sys-apps/systemd-31
	x11-misc/xdg-utils
	media-fonts/dejavu
	>=x11-themes/adwaita-icon-theme-3.30.0
	networkmanager? (
		net-misc/mobile-broadband-provider-info
		sys-libs/timezone-data )
	ibus? ( >=app-i18n/ibus-1.5.2[dconf(+),gtk,introspection] )
"
# avoid circular dependency, see bug #546134
PDEPEND="
	>=gnome-base/gdm-3.5[introspection]
	>=gnome-base/gnome-control-center-3.30.0[bluetooth(+)?,networkmanager(+)?]
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.17
	gnome-base/gnome-common
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
"

MAKEOPTS="-j1"

src_prepare() {
	# Change favorites defaults, bug #479918
	eapply "${FILESDIR}"/${PN}-3.22.0-defaults.patch

	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dsystemd=$(usex systemd true false)
		-Dnetworkmanager=$(usex networkmanager true false)
		-DBROWSER_PLUGIN_DIR="${EPREFIX}"/usr/$(get_libdir)/nsbrowser/plugins
	)
	meson_src_configure
}

src_compile() {
	cd "${BUILD_DIR}"
	meson_src_compile
}

multilib_src_compile() {
	cd "${BUILD_DIR}"
	meson_src_compile
}

src_install() {
	cd "${BUILD_DIR}"
	DESTDIR="${D}" eninja install
}

multilib_src_install() {
	cd "${BUILD_DIR}"
	DESTDIR="${D}" eninja install
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version 'media-libs/gst-plugins-good:1.0' || \
	   ! has_version 'media-plugins/gst-plugins-vpx:1.0'; then
		ewarn "To make use of GNOME Shell's built-in screen recording utility,"
		ewarn "you need to either install media-libs/gst-plugins-good:1.0"
		ewarn "and media-plugins/gst-plugins-vpx:1.0, or use dconf-editor to change"
		ewarn "apps.gnome-shell.recorder/pipeline to what you want to use."
	fi

	if has_version "<x11-drivers/ati-drivers-12"; then
		ewarn "GNOME Shell has been reported to show graphical corruption under"
		ewarn "x11-drivers/ati-drivers-11.*; you may want to switch to open-source"
		ewarn "drivers."
	fi

	if ! has_version "media-libs/mesa[llvm]"; then
		elog "llvmpipe is used as fallback when no 3D acceleration"
		elog "is available. You will need to enable llvm USE for"
		elog "media-libs/mesa."
	fi

	# https://bugs.gentoo.org/show_bug.cgi?id=563084
	if has_version "x11-drivers/nvidia-drivers[-kms]"; then
		ewarn "You will need to enable kms support in x11-drivers/nvidia-drivers,"
		ewarn "otherwise Gnome will fail to start"
	fi

	if ! systemd_is_booted; then
		ewarn "${PN} needs Systemd to be *running* for working"
		ewarn "properly. Please follow this guide to migrate:"
		ewarn "https://wiki.gentoo.org/wiki/Systemd"
	fi
}
