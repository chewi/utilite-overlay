# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit versionator

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="Freescale i.MX firmware"
HOMEPAGE="http://www.timesys.com/"
SRC_URI="http://repository.timesys.com/buildsources/${PN:0:1}/${PN}/${MY_P}/${MY_P}.bin"
LICENSE="Atheros-Firmware Freescale-EULA"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

S="${WORKDIR}/${MY_P}/firmware"

src_unpack() {
	eval local $(grep -a -m1 "^filesizes=" "${DISTDIR}/${A}")
	tail -c"${filesizes}" "${DISTDIR}/${A}" > "${P}.tar.bz2" || die
	unpack "./${P}.tar.bz2"
}

src_install() {
	# Don't install ar3k or ath6k/AR6003.
	# They are already in linux-firmware.

	insinto "/lib/firmware"
	doins -r sdma vpu

	insinto "/lib/firmware/ath6k"
	doins -r ath6k/AR6102
}
