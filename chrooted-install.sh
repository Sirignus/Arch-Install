#!/usr/bin/env bash

echo "-------------------------"
echo "Second part installation."

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

hwclock --systohc

echo '----------'
echo 'Setting up localization'
sed -i 's/^#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
timedatectl --no-ask-password set-timezone Europe/Paris
timedatectl --no-ask-password set-ntp 1
echo "LANG=fr_FR.UTF-8" >> /etc/locale.conf

echo "KEYMAP=fr-latin1" >> /etc/vconsole.conf

read -p "Please enter hostname (Name of Computer): " hostname

# Not sure what it does
hostnamectl --no-ask-password set-hostname $hostname
echo "$hostname" >> /etc/hostname

echo '----------'
echo 'Installing Network manager and enabling it'
pacman -S networkmanager --noconfirm
systemctl enable --now NetworkManager

echo '----------'
echo 'Making wheel group a sudoer'
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

echo '----------'
echo 'Enter password for Root'
passwd root


echo '----------'
echo 'Installing GRUB and microcode'

# Check for intel or amd microcode

if grep -q "Intel" <<< cat /proc/cpuinfo; then
    pacman -S intel-ucode --noconfirm
else
    pacman -S amd-ucode --noconfirm
fi

# Checks if EFI or BIOS Legacy

if [[ -d /sys/firmware/efi ]]; then
    pacman -S grub efibootmgr --noconfirm
    grub-install --target=x86_64-efi --efi-directory=/mnt/boot --bootloader-id=GRUB
else
    pacman -S grub --noconfirm

    echo "On what disk should GRUB be installed (ex /dev/sda)"
    read $DISK
    grub-install --target=i386-pc ${DISK}
fi
