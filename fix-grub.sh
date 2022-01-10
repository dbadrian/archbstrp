
#!/bin/bash

opts_btrfs=noatime,compress=zstd,discard=async,ssd

mount -o $opts_btrfs,subvol=@ /dev/disk/by-partlabel/system /mnt
mount -o $opts_btrfs,subvol=@home /dev/disk/by-partlabel/system /mnt/home
mount -o $opts_btrfs,subvol=@snapshots /dev/disk/by-partlabel/system /mnt/.snapshots
mount -o $opts_btrfs,subvol=@var /dev/disk/by-partlabel/system /mnt/var
mount LABEL=EFI /mnt/boot/

pacstrap /mnt grub efibootmgr

arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
