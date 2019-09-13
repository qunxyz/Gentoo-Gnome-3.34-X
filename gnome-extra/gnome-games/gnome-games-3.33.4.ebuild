# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_USE_DEPEND="vapigen"

inherit gnome2 vala meson

DESCRIPTION="Simple game launcher for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Games"

LICENSE="GPL-3"
SLOT="0"
IUSE="vala desktop dreamcast game-cube libretro love mame nintendo-ds playstation sega-cd sega-saturn steam turbografx-cd virtual-boy wii"

KEYWORDS="amd64 ~x86"

COMMON_DEPEND="
	gnome-base/gnome-desktop:3=
	>=dev-libs/libhandy-0.0.10
	>=sys-libs/libmanette-0.2.0
	>=sys-libs/retro-gtk-0.13.2
"

DEPEND="${COMMON_DEPEND}
	${vala_depend}
"

src_prepare() {
    vala_src_prepare
    default
}

src_configure() {
	local emesonargs=(
		$(meson_use desktop desktop-plugin)
		$(meson_use dreamcast dreamcast-plugin)
		$(meson_use game-cube game-cube-plugin)
		$(meson_use libretro libretro-plugin)
		$(meson_use love love-plugin)
		$(meson_use mame mame-plugin)
		$(meson_use nintendo-ds nintendo-ds-plugin)
		$(meson_use playstation playstation-plugin)
		$(meson_use sega-cd sega-cd-plugin)
		$(meson_use sega-saturn sega-saturn-plugin)
		$(meson_use steam steam-plugin)
		$(meson_use turbografx-cd turbografx-cd-plugin)
		$(meson_use virtual-boy virtual-boy-plugin)
		$(meson_use wii wii-plugin)
	)
	meson_src_configure
}
