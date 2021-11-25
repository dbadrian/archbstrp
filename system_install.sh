#!/bin/bash

# Partially based on https://github.com/mdaffin/arch-pkgs/blob/master/installer/install-arch
# Kudos to mdaffin

set -uo pipefail # exit on any failure
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

MIRRORLIST_URL="https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on"

pacman -Sy --noconfirm pacman-contrib dialog

echo "Updating mirror list"
curl -s "$MIRRORLIST_URL" | \
    sed -e 's/^#Server/Server/' -e '/^#/d' | \
    rankmirrors -n 5 - > /etc/pacman.d/mirrorlist



### Get information from user ###
hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

user=$(dialog --stdout --inputbox "Enter admin username" 0 0) || exit 1
clear
: ${user:?"user cannot be empty"}

password=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
clear
: ${password:?"password cannot be empty"}
password2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
clear
[[ "$password" == "$password2" ]] || ( echo "Passwords did not match"; exit 1; )

devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
device=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1
clear

### Set up logging ###
exec 1> >(tee "stdout.log")
exec 2> >(tee "stderr.log")

# Update system clock
timedatectl set-ntp true

### Setup the disk and partitions ###
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
swap_end=$(( $swap_size + 1024))MiB
echo "Using $swap_size MiB of swap"

# get rid of any partition tables etc.
sgdisk --zap-all ${device}

sgdisk --clear \
       --new=1:0:+550MiB --typecode=1:ef00 --change-name=1:EFI \
       --new=2:0:+${swap_size}GiB   --typecode=2:8200 --change-name=2:swap \
       --new=3:0:0       --typecode=3:8300 --change-name=3:system \
         $DRIVE

# EFI
mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI

# SWAP
mkfs.vfat -n EFI "${part_boot}"
mkswap -L swap /dev/disk/by-partlabel/swap
swapon -L swap

# SYSTEM / ROOT
mkfs.btrfs -f -L system /dev/disk/by-partlabel/system
mount -t btrfs LABEL=system /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var
umount -R /mnt

opts_btrfs=noatime,compress=zstd,discard=async,ssd

mount -t btrfs -o subvol=root,$o_btrfs LABEL=system /mnt

mount -o $o_btrfs,subvol=@ /dev/disk/by-partlabel/system /mnt
mkdir /mnt/home
mount -o $o_btrfs,subvol=@home /dev/disk/by-partlabel/system /mnt/home
mkdir /mnt/.snapshots
mount -o $o_btrfs,subvol=@snapshots /dev/disk/by-partlabel/system /mnt/.snapshots
mkdir -p /mnt/var
mount -o $o_btrfs,subvol=@var /dev/disk/by-partlabel/system /mnt/var

mount LABEL=EFI /mnt/boot

# install base system
pacstrap /mnt base linux linux-firmware amd-ucode git btrfs-progs zsh
pacstrap /mnt man-db man-pages bash-completion nano # replace "nano" with your favorite command line text editor

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# set hostname + networking
echo "${hostname}" > /mnt/etc/hostname
echo '127.0.0.1 localhost
::1   localhost
127.0.1.1 ${hostname}.localdomain  ${hostname}' > /etc/hosts

echo "LANG=en_GB.UTF-8" > /mnt/etc/locale.conf
arch-chroot /mnt locale-gen

arch-chroot /mnt useradd -mU -s /usr/bin/zsh -G wheel,uucp,video,audio,storage,games,input "$user"
arch-chroot /mnt chsh -s /usr/bin/zsh

echo "$user:$password" | chpasswd --root /mnt
echo "root:$password" | chpasswd --root /mnt

echo "continue by cloning the remaining repo"