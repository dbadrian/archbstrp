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

## Get information from user ###
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
swap_end=$(( $swap_size + 1024 + 550))MiB
echo "Using $swap_size+ 1024 MiB of swap"

# get rid of any partition tables etc.
sgdisk --zap-all ${device}

parted --script ${device} -- mklabel gpt \
  mkpart "EFI" fat32 1Mib 550MiB \
  set 1 boot on \
  mkpart "swap" linux-swap 550MiB ${swap_end} \
  mkpart "system" btrfs ${swap_end} 100%

# EFI
mkfs.vfat -n EFI /dev/disk/by-partlabel/EFI

# SWAP
mkswap -L swap /dev/disk/by-partlabel/swap
swapon -L swap

# SYSTEM / ROOT
mkfs.btrfs -f -L system /dev/disk/by-partlabel/system
mount -t btrfs LABEL=system /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var
umount -R /mnt

opts_btrfs=noatime,compress=zstd,discard=async,ssd

mount -o $opts_btrfs,subvol=@ /dev/disk/by-partlabel/system /mnt
mkdir /mnt/home
mount -o $opts_btrfs,subvol=@home /dev/disk/by-partlabel/system /mnt/home
mkdir /mnt/.snapshots
mount -o $opts_btrfs,subvol=@snapshots /dev/disk/by-partlabel/system /mnt/.snapshots
mkdir -p /mnt/var
mount -o $opts_btrfs,subvol=@var /dev/disk/by-partlabel/system /mnt/var

mkdir /mnt/boot
mount LABEL=EFI /mnt/boot/

# install base system
pacstrap /mnt base linux linux-firmware amd-ucode git btrfs-progs base-devel
pacstrap /mnt man-db man-pages nano pacman-contrib zsh dialog

# some networking
pacstrap /mnt openssh
arch-chroot /mnt systemctl enable sshd

pacstrap /mnt networkmanager
arch-chroot /mnt systemctl enable NetworkManager.service

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# set hostname + networking
echo "${hostname}" > /mnt/etc/hostname
echo '127.0.0.1 localhost
::1   localhost
127.0.1.1 ${hostname}.localdomain  ${hostname}' > /etc/hosts

echo "LANG=en_GB.UTF-8" > /mnt/etc/locale.conf
arch-chroot /mnt locale-gen

echo "Updating mirror list"
curl -s "$MIRRORLIST_URL" | \
    sed -e 's/^#Server/Server/' -e '/^#/d' | \
    rankmirrors -n 5 - > /mnt/etc/pacman.d/mirrorlist

echo "Setting default shell for created user"
arch-chroot /mnt useradd -mU -s /usr/bin/zsh -G wheel,uucp,video,audio,storage,games,input "$user"
arch-chroot /mnt chsh -s /usr/bin/zsh
touch /mnt/home/$user/.zshrc

echo "Setting passwords"
echo "$user:$password" | chpasswd --root /mnt
echo "root:$password" | chpasswd --root /mnt
echo "$user ALL=(ALL) ALL" >> /mnt/etc/sudoers.d/$user

echo "Setting up GRUB"
pacstrap /mnt grub efibootmgr

arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo ">>>>>>>> Basic System Installed <<<<<<<<"