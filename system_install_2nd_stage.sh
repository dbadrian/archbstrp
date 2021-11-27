#!/bin/bash

# This second stage still be run directly on the new system


set -uo pipefail # exit on any failure
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

MAKEFLAGS="-j$(nproc)"

echo "Installing SSH"
pacman -Syu --noconfirm openssh
echo "Enabling SSH"
systemctl enable sshd

cd /tmp

echo "Installing yay"
sudo pacman -S --noconfirm go
git clone https://aur.archlinux.org/yay.git
cd yay-bin
chown -R $user:$user
makepkg -si

# Install s
yay -Y --gendb
yay -Syu --devel

echo ">>>>>>>> Base System Installed <<<<<<<<"
