# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit versionator autotools-multilib

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="Freescale Multimedia VPU wrapper"
HOMEPAGE="http://www.timesys.com/"
SRC_URI="http://repository.timesys.com/buildsources/${PN:0:1}/${PN}/${MY_P}/${MY_P}.tar.gz"
LICENSE="Freescale-EULA"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND="media-libs/imx-vpu"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/0001-vpu_wrapper-fix-tests-of-return-value-from-IOGetVirt.patch"
)
