# Maintainer: Michael Daffin <michael@daffin.io>
pkgbase=dba
pkgname=(dba-base dba-desktop)
pkgver=1
pkgrel=1
pkgdesc="DBA setup"
arch=(any)
url="https://github.com/dbadrian/archbtsrp"
license=(MIT)
groups=(dba)

rootdir=$PWD

package_dba-base() {
    provides=(dba-base)
    conflicts=(dba-base)
    replaces=(dba-base)
    # install=dba-base.install

    # Core tools
    depends+=(
        nano
    )

    # Shell
    depends+=(
        bash-completion zsh zsh-completions
    )

    # Extra general packages
    depends+=(
        ripgrep exa fd wget fzf unzip zip dialog pacman-contrib bat ncdu ranger
    )
        # Filesystems
    depends+=(e2fsprogs exfat-utils dosfstools f2fs-tools)

    # Networking
    depends+=(nftables iw iwd avahi nss-mdns openssh)

    # General tools
    depends+=(git cmake)
}


package-dba-devel() {
    # Docker
    depends+=(docker docker-compose dnsmasq rancher-k3d-bin kubectl k9s kind)
}

package_dba-desktop() {
    install=dba-desktop.install

    depends=(dba-base)

    # I3 Desktop
    depends+=(i3-wm i3status i3blocks i3lock rofi)

    optdepends=(okular)

    optdepends+=(brightnessctl)
}
