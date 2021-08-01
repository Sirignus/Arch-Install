#!/usr/bin/env bash

echo 'Installing Arch Linux'

timedatectl set-ntp true

PS3="Create partition table and partitions ?"

select answer in "Yes" "Already done" "exit"
do
    if [ $REPLY -eq 1 ]; then
        echo '------------------'
        lsblk
        echo "Please enter disk to format: (example /dev/sda)"
        read DISK
        echo "Which system should be installed ?"
        select s in "EFI" "BIOS LEGACY"
        do
            if [ $s in "EFI" ]; then
                parted ${DISK} mklabel gpt mkpart "EFI system partition" fat32 1MiB 512MiB
                parted ${DISK} set 1 esp on
                parted ${DISK} mkpart "ROOT" ext4 512MiB 100%
                
                mkfs.vfat -F32 -n "EFI system partition" "${DISK}1"
                mkfs.ext4 -L "ROOT" "${DISK}2"

                mkdir /mnt
                mkdir /mnt/boot
                mkdir /mnt/boot/efi

                mount -t ext4 "${DISK}2" /mnt
                mount -t vfat "${DISK}1" /mnt/boot
            elif [ $s in "BIOS LEGACY" ]; then
                parted ${DISK} mklabel msdos mkpart primary ext4 1MiB 100%
                parted ${DISK} set 1 boot on
                
                mkfs.ext4 -L "ROOT" "${DISK}1"

                mkdir /mnt 
                mount -t ext4 "${DISK}1" /mnt
            fi
        done
    elif [ $REPLY -eq 3 ]; then
        exit 0
    fi
done

echo '----------'
echo 'Installing nano, git, sudo and firefox alongside linux'
pacstrap /mnt base base-devel linux linux-firmware nano git sudo firefox man-db --noconfirm --needed

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

hwclock --systohc

echo '----------'
echo 'Setting up localization'
sed -i 's/^#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone Europe/Paris
timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="fr_FR.UTF-8" LC_COLLATE="" LC_TIME="fr_FR.UTF-8"

localectl --no-ask-password set-keymap fr

read -p "Please enter hostname (Name of Computer): " hostname

hostnamectl --no-ask-password set-hostname $hostname

echo '----------'
echo 'Installing Network manager and enabling it'
pacman -S networkmanager --noconfirm
systemctl enable --now NetworkManager

echo '----------'
echo 'Making wheel group a sudoer'
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/'

echo '----------'
echo 'Enter password for Root'
passwd root


PS3="Install GRUB on efi or boot"

echo '----------'
echo 'Installing GRUB and microcode'
pacman -S grub --noconfirm

# Checks if EFI or BIOS Legacy

#if [[ -d /sys/firmware/efi ]]; then
#    pacman -S efibootmgr --noconfirm
#fi