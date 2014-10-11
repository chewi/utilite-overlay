# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib toolchain-funcs versionator

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="i.MX6 Vivante proprietary GPU drivers"
HOMEPAGE="http://www.timesys.com/"
SRC_URI="http://repository.timesys.com/buildsources/${PN:0:1}/${PN}/${MY_P}/${MY_P}.tar.gz"
LICENSE="Timesys-EULA"
SLOT="0"
KEYWORDS="-* ~arm"
IUSE="directfb samples static-libs"

QA_PREBUILT="*"

DEPEND="app-admin/eselect-vivante"

RDEPEND="${DEPEND}
	>=sys-libs/glibc-2.4
	directfb? ( =dev-libs/DirectFB-1.6* )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Remove symlinks that will be handled by eselect.
	find -lname "*-fb.so" -delete || die

	# C macro should be __linux__, not LINUX.
	sed -i "s/defined(LINUX)/defined(__linux__)/g" \
		*/usr/include/*.h */usr/include/*/*.h || die

	for FP in hardfp softfp; do
		cd "${S}/${FP}/usr/lib" || die

		# libGL has the wrong soname. This confuses eselect-opengl. Yes,
		# this is evil but do you know a better way? Thought not.
		sed -i "s/libGL\.so\.1\.2/libGL.so.1\x00\x00/g" libGL.so.1.2 || die

		# Remove some duplicate files with symlinks.
		ln -snf libGL.so.1.2 libGL.so || die
		ln -snf libGL.so.1.2 libGL.so.1 || die

		# These symlinks are just missing.
		# Link the other way to make eselecting easier.
		ln -snf libEGL.so libEGL.so.1 || die
		ln -snf libEGL.so libEGL.so.1.0 || die
		ln -snf libGLESv2.so libGLESv2.so.2 || die
		ln -snf libGLESv2.so libGLESv2.so.2.0.0 || die

		# Move OpenVG libraries to a subdirectory because they confuse
		# ldconfig. 3D is for S/DL and 355 is for D/Q.
		mkdir VG || die
		mv libOpenVG_*.so VG || die
		rm libOpenVG.so || die

		# Move backends into subdirectories because they confuse
		# eselect-opengl and this makes eselect-vivante simpler.
		local BACKEND LIB

		for BACKEND in "dfb DirectFB" "fb Framebuffer" "wl Wayland"; do
			local DIR="backends/${BACKEND#* }"
			local SUFFIX="${BACKEND% *}"

			mkdir -p "${DIR}" || die

			for LIB in *-"${SUFFIX}".so; do
				mv "${LIB}" "${DIR}/${LIB/-${SUFFIX}}" || die
				ln -snf "backends/current/${LIB/-${SUFFIX}}" || die
			done
		done
	done
}

src_install() {
	if [[ "$(tc-is-softfloat)" = "no" ]]; then
		cd hardfp || die
	else
		cd softfp || die
	fi

	if use samples; then
		dodir "/opt"
		cp -r opt/viv_samples "${D}opt/" || die
	fi

	# Leave out .pc files present in Mesa.
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins usr/lib/pkgconfig/{gc_wayland_protocol,wayland-viv}.pc

	local FINDARGS=()
	local GLDIR="/usr/$(get_libdir)/opengl/vivante"

	use directfb || FINDARGS+=(! -iname '*directfb*' ! -iname '*dfb*')
	use static-libs || FINDARGS+=(! -iname '*.a' ! -iname '*.la')

	insinto "${GLDIR}/include"
	doins -r usr/include/*

	insopts -m0755

	insinto "${GLDIR}/lib"
	doins $(find usr/lib ! -type d -maxdepth 1 "${FINDARGS[@]}")
	doins -r usr/lib/VG

	insinto "${GLDIR}/lib/backends"
	doins -r $(find usr/lib/backends -mindepth 1 -maxdepth 1 "${FINDARGS[@]}")

	insinto "/usr/$(get_libdir)"
	use directfb && doins -r usr/lib/directfb-1.6-0
}

pkg_postinst() {
	echo
	eselect vivante-backend update --if-unset
	eselect vivante-openvg update --if-unset
}
