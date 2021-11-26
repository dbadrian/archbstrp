#!/bin/bash

# This second stage still be run directly on the new system


set -uo pipefail # exit on any failure
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

MIRRORLIST_URL="https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on"
MAKEFLAGS="-j$(nproc)"

echo "Updating mirror list"
curl -s "$MIRRORLIST_URL" | \
    sed -e 's/^#Server/Server/' -e '/^#/d' | \
    rankmirrors -n 5 - > /etc/pacman.d/mirrorlist

echo "Installing SSH"
pacman -Syu --noconfirm openssh
echo "Enabling SSH"
systemctl enable sshd

echo "Installing yay"
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

# Install s
yay -Syu bash-completion zsh zsh-completions nano
vi
echo ">>>>>>>> Basic System Installed <<<<<<<<"
