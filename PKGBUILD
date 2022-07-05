# Maintainer: Look <notkool@protonmail.com>
pkgname=miru-bin
pkgver=2.7.5
pkgrel=1
pkgdesc="Bittorrent streaming software for cats"
arch=('x86_64' 'aarch64')
url="https://github.com/ThaUnknown/miru"
license=('GPL-3.0')
depends=('xdg-utils')
options=('!strip' '!emptydirs')
install=${pkgname}.install
source_x86_64=("https://github.com/ThaUnknown/miru/releases/download/v${pkgver}/linux-amd64-Miru-${pkgver}.deb")
sha512sums_x86_64=('SKIP')
source_aarch64=("https://github.com/ThaUnknown/miru/releases/download/v${pkgver}/linux-arm64-Miru-${pkgver}.deb")
sha512sums_aarch64=('SKIP')

package(){

	# Extract package data
	tar -xJ -f data.tar.xz -C "${pkgdir}"

	install -D -m644 "${pkgdir}/opt/Miru/LICENSES.chromium.html" "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"

}
