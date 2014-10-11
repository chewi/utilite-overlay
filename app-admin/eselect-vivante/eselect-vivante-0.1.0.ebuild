# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Switches Vivante acceleration backend and OpenVG library"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

RDEPEND=">=app-admin/eselect-1.4.2"

S="${FILESDIR}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "vivante-backend-${PV}.eselect" vivante-backend.eselect
	newins "vivante-openvg-${PV}.eselect" vivante-openvg.eselect
}
