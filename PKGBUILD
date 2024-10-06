# Maintainer: Michael Daffin <michael@daffin.io>
pkgbase=dba
pkgname=(dba-base dba-desktop dba-dev dba-image dba-circuit dba-arduino dba-notes dba-tex dba-finance )
pkgver=1
pkgrel=37
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
    install=dba-base.install

    # Core tools
    depends+=(
        dialog
        pacman-contrib
        nano
        tmux
        tree
    )

    # arch tools
    depends+=(
#        auracle-git
        downgrade
        pkgtools
        pacman-cleanup-hook
    )

    # Display manager
    depends+=(
        ly
    )

    # Shell
    depends+=(
        bash-completion zsh zsh-completions
    )

    # Extra general packages
    depends+=(
        htop        # status 
        glances-git # status
        ripgrep     # faster grep
        exa     # ls replacement
        fd      # find replacement
        wget    # you know
        fzf     # fuzzy command line finder
        bat     # cat alternative
        ncdu    # file sizes finder
        ranger  # console file explorer
    )

    # compression related things
    depends+=(
        unzip
        zip
        p7zip
    )

    # Filesystems
    depends+=(
        e2fsprogs
        exfat-utils
        dosfstools
        btrfs-progs
        ntfs-3g
        sshfs
        compsize # btrfs compression rate
        dislocker # bitlocker access
	mtpfs # mobile phoe
    )

    # Networking / Keys
    depends+=(openssh)

    # keys and passwords
    depends+=(gnome-keyring gnupg pass)

    # General tools
    depends+=(git cmake diff-so-fancy gitg)

    # Backup solutions and other file related things
    depends+=(restic rsync)

    # hardware tools
    depends+=(lm_sensors i2c-tools)
}


package_dba-desktop() {
    install=dba-desktop.install

    depends=(dba-base)

    # text editor
    depends+=(sublime-text-3)

    # Xorg
    depends+=(
        xorg-server
        xorg-xinit
        # xorg-apps
        arandr
    )

    # I3 Desktop
    depends+=(i3-wm i3status i3blocks i3lock i3wsr dmenu xss-lock)

    # GPU hardware
    depends+=(xf86-video-amdgpu mesa radeontop) # vulkan-radeon

    # video acceleration
    depends+=(libva-mesa-driver mesa-vdpau libva-utils vdpauinfo)

    # terminal stuff
    depends+=(terminator)

    # browsers
    depends+=(firefox google-chrome)

    # audio
    depends+=(
        alsa-utils
        pipewire
        pipewire-alsa
        pipewire-jack
        pipewire-pulse
        wireplumber
        pavucontrol
        libldac
        # pulseaudio-modules-bt # conflicts pipewire now
    )

    # connectivity
    depends+=(
        wpa_supplicant
        networkmanager
        network-manager-applet
    )

    # bluetooth
    depends+=(bluez bluez-utils blueman)

    # messengers
    depends+=(signal-desktop telegram-desktop zoom skypeforlinux-stable-bin)

    # keys/ pass /gnupg
    depends+=(seahorse)

    # printing
    depends+=(
        cups
        cups-pdf # to print pdfs
        hplip
        kyocera-ecosys-m552x-p502x
    )

    # media
    depends+=(
        mplayer
        vlc
    )

    # downloader stuff
    depends+=(
        aria2
        wget
    )

    # console tools
    depends+=(
        genius
        # ansiweather
        # colout-git # color arbritary console outpit
        # fasd-git # faster console stuff, not sure if needed with zsh
    )

    # archive/compress
    depends+=(
        file-roller
    )

    #qol
    depends+=(
        flameshot
        redshift-git
        redshift-gtk-git
    )

    # PDF
    depends+=(
        okular
        masterpdfeditor
    )
}


package_dba-dev() {

    depends=(dba-desktop)

    # Docker
    depends+=(docker docker-compose)

    # vscode
    depends+=(visual-studio-code-bin)

    # more git related stuff
    depends+=(
        gitg
        kdiff3
    )

    # coverage
    depends+=(
        lcov
    )

    # flutter/android related
    depends+=(
        android-platform
        android-sdk
        android-sdk-build-tools
        android-sdk-cmdline-tools-latest
        android-sdk-platform-tools
        # android-studio
        # flutter-group-pacman-hook # only needed if flutter is installed!?
    )

    # some hardware related debugging tools
    depends+=(
        usbtop
    )

    # binary analysis tools
    depends+=(
        bytewalk
        binwalk
        ddrescue
        # jd-gui # java decompiler
    )

    # compiler
    depends+=(
        ccache
        clang
        cloc
    )

    # rest debugging and stuff
    depends+=(
        postman-bin
    )

    # devtools
    #################################
    # act # github actions testing 
    # 

}

package_dba-finance() {
    depends=(dba-desktop)

    depends+=(
        hibiscus
        jameica
    )
}

package_dba-image() {
    depends=(dba-desktop)

    depends+=(
        darktable
        inkscape
        gimp
    )
}

package_dba-tex() {
    depends=(dba-desktop)

    depends+=(
        # texlive-most
        texlive-langjapanese
        # texlive-localmanager-git
        texstudio
    )
}

package_dba-notes() {
    depends=(dba-desktop)

    depends+=(
        zotero
        # joplin-desktop
        libreoffice-fresh
        libreoffice-fresh-de
    )
}

package_dba-arduino() {
    depends=(dba-desktop)

    depends+=(
        adafruit-ampy
        # arduino-ide
        rshell
        avrdude
        minicom
    )
}


package_dba-font() {
    depends=(dba-base)

    depends+=(
        # acroread-fonts-systemwide
        # adobe-base-14-fonts
        # awesome-terminal-fonts-git
        # awesome-terminal-fonts-patched
        # ttf-inconsolata-g
        # ttf-koruri
        # ttf-monapo
        # ttf-mplus
        # ttf-ms-fonts
        # ttf-vlgothic
        # otf-eb-garamond
    )
}

package_dba-circuit() {
    depends+=(
        veroroute
        owon-vds-tiny
        qucs
        kicad
        kicad-library
        # gspiceui
        # ngspice-git
    )
}


# package_dba-music() {
#     depends+=(
#         # vcvrack-git
#         libopenaptx
#     )
# }

# package_dba-laptop() {
#     depends+=(
#         # laptop-mode-tools
#         # intelbacklight-git
#     )
# }

# hardware
#################################
# openrgb
# zenmonitor3-git
# zenpower3-dkms

# 6502 shit
#################################
# asm6f
# dasm

# multilingual
#################################
# uim
# ibus-qt
