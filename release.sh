#!/bin/bash

export RELEASES="$(mktemp /tmp/miru-bin-update.XXX)"

if ! [[ -z "$GITHUB_TOKEN" ]]; then
	export AUTH="-H \"Authorization: Bearer $GITHUB_TOKEN\""
fi

# Get releases list from api
curl -s $AUTH https://api.github.com/repos/ThaUnknown/miru/releases > "$RELEASES"

# Get file with hashes from latest release
export LATEST_LINUX=$(cat "$RELEASES" | grep 'browser.*latest-linux.yml' | head -n 1 | awk -F'"' '{ print $4 }')

# Get latest tag
export PKGVER="$(cat "$RELEASES" | grep tag_name | head -n 1 | awk -F '"' '{ print $4 }' | tr -d 'v')"

# Download checksum from file
export SHA_512_SUM="$(curl -sL $AUTH "$LATEST_LINUX" | grep -A 1 '.deb' | tail -n 1 | awk '{ print $2 }')"

# Check errors
if [[ -z "$PKGVER" || -z "$SHA_512_SUM" ]]; then
	echo Api error.
	exit 1
fi

# Decode checksum https://github.com/electron-userland/electron-builder/issues/3913#issuecomment-1018263468
export SHA_512_SUM="$(echo "$SHA_512_SUM" | base64 -d | hexdump -ve '1/1 "%.2x"')"

cat <<EOF > PKGBUILD
# Maintainer: Look <notkool@protonmail.com>
pkgname=miru-bin
pkgver=$PKGVER
pkgrel=1
pkgdesc="Bittorrent streaming software for cats"
arch=('x86_64')
url="https://github.com/ThaUnknown/miru"
license=('GPL-3.0')
depends=('xdg-utils')
options=('!strip' '!emptydirs')
install=\${pkgname}.install
_pkgname="miru"
source_x86_64=(
	"https://github.com/ThaUnknown/miru/releases/download/v\${pkgver}/linux-Miru-\${pkgver}.deb"
	"\${_pkgname}.desktop"
)
sha512sums_x86_64=(
	'$SHA_512_SUM'
	'10ffce928a1f1785c78b23bd928e718a49f2243418aadd6e4537d83151c920ab270d7345e54646ae65351f855bdd41e41a9d3f0a94a128d618d85d9cc59e1e06'
)

package() {

	# Extract package data
	tar -xJ -f data.tar.xz -C "\${pkgdir}"

	install -D -m644 "\${pkgdir}/opt/Miru/LICENSES.chromium.html" "\${pkgdir}/usr/share/licenses/\${pkgname}/LICENSE"
	install -D -m644 \${srcdir}/\${_pkgname}.desktop "\${pkgdir}/usr/share/applications/\${_pkgname}.desktop"
}
EOF

cat <<EOF > .SRCINFO
pkgbase = miru-bin
	pkgdesc = Bittorrent streaming software for cats
	pkgver = $PKGVER
	pkgrel = 1
	url = https://github.com/ThaUnknown/miru
	install = miru-bin.install
	arch = x86_64
	license = GPL-3.0
	depends = xdg-utils
	options = !strip
	options = !emptydirs
	source_x86_64 = https://github.com/ThaUnknown/miru/releases/download/v${PKGVER}/linux-Miru-${PKGVER}.deb
	source_x86_64 = miru.desktop
	sha512sums_x86_64 = $SHA_512_SUM
	sha512sums_x86_64 = 10ffce928a1f1785c78b23bd928e718a49f2243418aadd6e4537d83151c920ab270d7345e54646ae65351f855bdd41e41a9d3f0a94a128d618d85d9cc59e1e06

pkgname = miru-bin
EOF

git add .
git commit -m "chore(release): v$PKGVER"
