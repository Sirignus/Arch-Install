#!/usr/bin/env bash

echo 'Installing Arch Linux'

timedatectl set-ntp true

PS3="Create partition table and partitions ? "

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
            if [ "$s" == "EFI" ]; then
                parted ${DISK} mklabel gpt 
                parted ${DISK} mkpart "EFI system partition" fat32 1MiB 512MiB
		parted ${DISK} set 1 esp on
                parted ${DISK} mkpart "ROOT" ext4 512MiB 100%
                
                mkfs.vfat -F32 -n "EFI system partition" "${DISK}1"
                mkfs.ext4 -L "ROOT" "${DISK}2"

#                mkdir /mnt
                mkdir /mnt/boot
                mkdir /mnt/boot/efi

                mount -t ext4 "${DISK}2" /mnt
                mount -t vfat "${DISK}1" /mnt/boot
            elif [ "$s" == "BIOS LEGACY" ]; then
                parted ${DISK} mklabel msdos
                parted ${DISK} mkpart primary ext4 1MiB 100%
		parted ${DISK} set 1 boot on
                
                mkfs.ext4 -L "ROOT" "${DISK}1"

#                mkdir /mnt 
                mount -t ext4 "${DISK}1" /mnt
		break
            fi
        done
    elif [ $REPLY -eq 3 ]; then
        exit 0
    fi
    break
done

echo '----------'
echo 'Installing nano, git, sudo and firefox alongside linux'
pacstrap /mnt base base-devel linux linux-firmware nano git sudo firefox man-db --noconfirm --needed

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
