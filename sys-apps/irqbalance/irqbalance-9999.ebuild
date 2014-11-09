# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/dv1/irqbalanced.git"
AUTOTOOLS_AUTORECONF=true

inherit autotools-utils systemd git-r3

DESCRIPTION="Distribute hardware interrupts across processors on a multiprocessor system"
HOMEPAGE="https://github.com/dv1/irqbalanced"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE="caps"

RDEPEND="dev-libs/glib:2
	caps? ( sys-libs/libcap-ng )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myeconfargs=( $(use_with caps libcap-ng) )
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	newinitd "${FILESDIR}"/irqbalance.init.3 irqbalance
	newconfd "${FILESDIR}"/irqbalance.confd-1 irqbalance
	systemd_dounit "${FILESDIR}"/irqbalance.service
}
