# Copyright 2016-2017 Jan Chren (rindeal)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit rindeal

# to unpack .deb archive
inherit unpacker

DESCRIPTION="Universal markup converter"
HOMEPAGE="https://pandoc.org https://github.com/jgm/pandoc"
LICENSE="GPL-2"

MY_PN="${PN//-bin/}"

SLOT="0"
SRC_URI="amd64? ( https://github.com/jgm/pandoc/releases/download/${PV}/${MY_PN}-${PV}-1-amd64.deb )"

KEYWORDS="-* amd64"
IUSE="citeproc"
RESTRICT+=" mirror"

CDEPEND="
	dev-libs/gmp:*
	sys-libs/zlib:*
"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}
	!app-text/pandoc
	citeproc? ( !dev-haskell/pandoc-citeproc )
"

S="${WORKDIR}"

src_prepare() {
	default

	# docs are gzipped
	find -name "*.gz" | xargs gunzip
	assert
}

src_install() {
	cd "${S}"/usr/bin || die
	dobin "${MY_PN}"
	use citeproc && dobin 'pandoc-citeproc'

	cd "${S}"/usr/share/man/man1 || die
	doman "${MY_PN}.1"
	use citeproc && doman 'pandoc-citeproc.1'
}

QA_EXECSTACK="usr/bin/pandoc"
QA_PRESTRIPPED="usr/bin/pandoc"
