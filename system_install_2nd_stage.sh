#!/bin/bash

# This second stage still be run directly on the new system


set -uo pipefail # exit on any failure
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

EMAIL=$(dialog --stdout --inputbox "Enter email" 0 0) || exit 1
clear
: ${EMAIL:?"email cannot be empty"}

GITHUB_USERNAME=$(dialog --stdout --inputbox "Github username" 0 0) || exit 1
clear
: ${GITHUB_USERNAME:?"email cannot be empty"}

GITHUB_KEY_NAME=$(dialog --stdout --inputbox "Github key name for this machine" 0 0) || exit 1
clear
: ${GITHUB_KEY_NAME:?"email cannot be empty"}

EMAIL="dawidh.adrian@googlemail.com"
GITHUB_USERNAME="dbadrian"
GITHUB_KEY_NAME="laptop"

############## DO NOT MODIFY BELOW THIS LINE ###########
# This does not resolve from a symlink location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

########################################################
##################### Function Def #####################
########################################################

yes_or_no_run() {
    echo -e ${1}
    select yn in "Yes" "No"; do
    case $yn in
        Yes ) ${@:2}; break;;
        No ) break;;
    esac
    done
}

create_ssh_key() {
    ssh-keygen -t rsa -b 4096 -C "${1}"
}

########################################################
##################### Main Routine #####################
########################################################

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
