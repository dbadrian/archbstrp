# Maintainer: Michael Daffin <michael@daffin.io>
pkgbase=dba
pkgname=(dba-base dba-desktop dba-dev dba-image dba-circuit dba-arduino dba-notes dba-tex dba-finance)
pkgver=1
pkgrel=41
pkgdesc="Provides standard packages I want on my personal (home) setup for working and daily life."
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
    depends+=(
        git
        cmake
        diff-so-fancy 
        gitg # ui for git
        lazygit # tui for git
        bfg # faster filter of troublesome blobs in git (cf. git-filter-branch)
        jq # json formattting
    )

    # Backup solutions and other file related things
    depends+=(restic rsync backblaze-b2)

    # hardware tools
    depends+=(
      lm_sensors # sensors access (cpu, nvme e.g.)
      i2c-tools # above
      f3 # test flash devices
      
    )
}

package_dba-systembenchmark() {
    depends=(dba-base)

    depends+=(
      geekbench
      mprime
      glances-git

    )
}

package_dba-desktop() {
    install=dba-desktop.install

    depends=(dba-base)

    # text editor
    depends+=(neovim)

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
    depends+=(libva-mesa-driver libva-utils vdpauinfo libdxvk lib32-libdxvk)

    # terminal stuff
    depends+=(wezterm)

    # browsers
    depends+=(firefox google-chrome)

    # vpn
    depends+=(mullvad-vpn-bin)

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
    depends+=(signal-desktop zoom)

    # keys/ pass /gnupg
    depends+=(
      seahorse
      ausweisapp2
    )

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
        vlc-plugins-all
    )

    # downloader stuff
    depends+=(
        aria2
        wget
    )

    # console tools
    depends+=(
        genius
        bmon # network monitoring
        usbmon # usb monitoring
        usbtop #...
    )

    # files/archive/compress
    depends+=(
        file-roller
        baobab
    )

    #qol
    depends+=(
        flameshot
        redshift-git
        redshift-gtk-git
        caffeine-ng
    )

    # PDF
    depends+=(
        okular
        masterpdfeditor
    )

    # ebooks
    depends+=(
      calibre
    )

    # gaming
    depends+=(
      steam
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
        zig
        odin
    )

    # rest debugging and stuff
    depends+=(
        postman-bin  # for api/rest
        ghidra # reverse engineering
        go-task # task runner
        uv # poetry alternative
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
        zotero-bin
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
        nodemcu-pyflasher
    )
}


package_dba-font() {
    depends=(dba-base)

    depends+=(
       nerd-fonts
    )
}

package_dba-circuit() {
    depends+=(
        veroroute
        owon-vds-tiny
        qucs
        kicad
        kicad-library
        esp-idf
        esphome # not really for circuit design but well...
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
