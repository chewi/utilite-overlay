# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils linux-info toolchain-funcs versionator multilib-minimal

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="Freescale i.MX platform libraries"
HOMEPAGE="http://www.timesys.com/"
SRC_URI="http://repository.timesys.com/buildsources/${PN:0:1}/${PN}/${MY_P}/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
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
		LD="$(tc-getLD)" \
		PLATFORM="IMX6Q" \
		INCLUDE="-I${KERNEL_DIR}/include/uapi -I${KERNEL_DIR}/include"
}

multilib_src_install() {
	emake install \
		DEST_DIR="${D}" \
		PLATFORM="IMX6Q"
}
