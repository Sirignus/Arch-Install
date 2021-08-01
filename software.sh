#!/usr/bin/env bash

echo -e "\nInstalling Softwares\n"

PKGS=(
    # Development tools
        'code'
    
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo '------------------'
echo "DONE."