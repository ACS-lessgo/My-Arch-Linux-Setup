#!/bin/bash

# Wi-Fi Setup
iwctl
device list
station wlan0 scan
station wlan0 get-networks
echo -n "Enter Wi-Fi network name: "
read wifi_name
station wlan0 connect "$wifi_name"
ping -c 5 8.8.8.8

# Disk Partitioning
lsblk
gdisk nvme0n1 <<EOF
n
1
+512M
ef00
n
2

w
EOF
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.btrfs /dev/nvme0n1p2 -f
mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
umount /mnt
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@ /dev/nvme0n1p2 /mnt
mkdir -p /mnt/{boot/efi,home,var}
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@home /dev/nvme0n1p2 /mnt/home
mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@var /dev/nvme0n1p2 /mnt/var
mount /dev/nvme0n1p1 /mnt/boot/efi

# Installation
pacstrap /mnt base linux linux-lts linux-firmware git nano intel-ucode btrfs-progs sudo
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt <<CHROOT

# Chrooted Environment
cat <<CHROOT_FSTAB > /etc/fstab
# /etc/fstab
# ...
CHROOT_FSTAB

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
nano /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "ArchKDE" > /etc/hostname
echo "127.0.0.1   localhost" >> /etc/hosts
echo "::1         localhost" >> /etc/hosts
echo "127.0.1.1   ArchKDE.localdomain ArchKDE" >> /etc/hosts

passwd

pacman -S grub efibootmgr networkmanager dialog mtools dosfstools base-devel linux-headers linux-lts-headers xdg-utils xdg-user-dirs pulseaudio pulseaudio-bluetooth wireless_tools

# Final Steps
exit
CHROOT

umount -R /mnt
reboot

echo "Arch Linux installation and setup complete."
