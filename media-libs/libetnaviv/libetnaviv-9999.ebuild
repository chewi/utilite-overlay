# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 multilib-minimal

EGIT_REPO_URI="https://github.com/etnaviv/etna_viv.git"

DESCRIPTION="Userspace driver for the Vivante GCxxx GPU series"
HOMEPAGE="https://github.com/etnaviv/etna_viv"
SRC_URI=""
LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

S="${WORKDIR}/${P}/src/etnaviv"

pkg_setup() {
	if [[ -z "${GCABI}" ]]; then
		export GCABI="imx6_v4_6_9"
		ewarn "Defaulting to GCABI=imx6_v4_6_9. This is correct for i.MX6 hardware"
		ewarn "running Linux 3.10.17. See the \"include\" directories located at"
	else
		ewarn "Using GCABI=${GCABI}. See the \"include\" directories located at"
	fi

	ewarn "${HOMEPAGE}/tree/master/src for other"
	ewarn "other possible values."
}

src_prepare() {
	sed -i -r \
		-e "s/-O[0-9]+//g" \
		-e "s/-g[^ ]*[0-9]+//g" \
		../Makefile.inc || die

	multilib_copy_sources
}

multilib_src_compile() {
	emake GCCPREFIX="${CHOST}-"
}

multilib_src_install() {
	dolib.a "${PN}.a"
}

multilib_src_install_all() {
	dodoc README.md
	insinto /usr/include/etnaviv
	doins *.h
}
