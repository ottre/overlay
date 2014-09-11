# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils

DESCRIPTION="A daemon that monitors directories and reacts to file system events in them"
HOMEPAGE="http://www.gnu.org.ua/software/direvent/direvent.html"
SRC_URI="http://ftp.gnu.org/gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls"

DEPEND="sys-apps/texinfo
		nls? ( sys-devel/gettext )"
RDEPEND=""

src_configure() {
	if use nls; then
		strip-linguas -i po/
	fi

	econf $(use_enable nls)
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.init ${PN}
}

pkg_postinst() {
	elog "To use this daemon as a regular user:"
	elog "1. Run 'sudo ln -s /etc/init.d/${PN} /etc/init.d/${PN}.\$USER'"
	elog "2. Create the config file '${PN}.conf' in your home directory"
	elog "3. Run 'sudo rc-update add ${PN}.\$USER default'"
	elog "4. Run 'sudo rc-service ${PN}.\$USER start'"
}

pkg_postrm() {
	if [ -L /etc/init.d/${PN}.* ]; then
		elog "There are broken symlinks to the ${PN} init script in /etc/init.d."
		elog "To clean up, run:"
		elog "1. for symlink in /etc/init.d/${PN}.*; do"
		elog "2. rc-update delete \${symlink##*/}"
		elog "3. rm \$symlink"
		elog "4. done"
	fi
}
