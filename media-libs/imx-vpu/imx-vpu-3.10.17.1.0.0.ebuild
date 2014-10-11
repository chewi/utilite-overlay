# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs versionator multilib-minimal

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="Freescale i.MX VPU library"
HOMEPAGE="http://www.timesys.com/"
SRC_URI="http://repository.timesys.com/buildsources/${PN:0:1}/${PN}/${MY_P}/${MY_P}.bin"
LICENSE="Freescale-EULA"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	eval local $(grep -a -m1 "^filesizes=" "${DISTDIR}/${A}")
	tail -c"${filesizes}" "${DISTDIR}/${A}" > "${P}.tar.bz2" || die
	unpack "./${P}.tar.bz2"
}

src_prepare() {
	epatch "${FILESDIR}/0001-IOGetVirtMem-returns-1-MAP_FAILED-on-failure.patch"
	epatch "${FILESDIR}/obey-variables.patch"
	multilib_copy_sources
}

multilib_src_configure() {
	sed -i "s:/usr/lib:/usr/$(get_libdir):g" */Makefile || die
}

multilib_src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		PLATFORM="IMX6Q"

}

multilib_src_install() {
	emake install \
		DEST_DIR="${D}" \
		PLATFORM="IMX6Q"
}
