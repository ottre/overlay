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
KEYWORDS="~amd64 ~x86"
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
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/${PN}.init ${PN}

	dodoc AUTHORS ChangeLog NEWS README THANKS
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
		rm /etc/init.d/${PN}.* || die
	fi
}
