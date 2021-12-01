# Maintainer: Michael Daffin <michael@daffin.io>
pkgbase=dba
pkgname=(dba-base dba-desktop)
pkgver=1
pkgrel=11
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
    depends+=(e2fsprogs exfat-utils dosfstools btrfs-progs ntfs-3g)

    # Networking
    depends+=(openssh)

    # General tools
    depends+=(git cmake diff-so-fancy)

    # Backup solutions
    depends+=(restic)

    # hardware tools
    depends+=(lm_sensors i2c-tools)
}


package-dba-devel() {
    # Docker
    depends+=(docker docker-compose dnsmasq rancher-k3d-bin kubectl k9s kind)
}

package_dba-desktop() {
    install=dba-desktop.install

    depends=(dba-base)
 
    # Xorg
    depends+=(xorg-server xorg-xinit arandr) # xorg-apps)

    # I3 Desktop
    depends+=(i3-wm i3status i3blocks i3lock dmenu xss-lock)

    # GPU hardware
    depends+=(xf86-video-amdgpu mesa vulkan-radeon)

    # video acceleration
    depends+=(libva-mesa-driver mesa-vdpau libva-utils vdpauinfo)

    # terminal stuff
    depends+=(terminator)

    # browsers
    depends+=(firefox) # google-chrome)

    # audio
    depends+=(pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber)

    # bluetooth
    depends+=(bluez bluez-utils)

    optdepends=(okular)

    optdepends+=(brightnessctl)
}

