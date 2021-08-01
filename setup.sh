#!/usr/bin/env bash

# Post install script. 
# Setup Window Manager/Desktop Environment
# Then install usual softwares

echo -e "\nInstalling Qtile\n"

PKGS=(

    # --- XORG Display Rendering
        'xorg'                  # Base Package
        'xorg-drivers'          # Display Drivers 
        'xterm'                 # Terminal for TTY
        'xorg-server'           # XOrg server
        'xorg-apps'             # XOrg apps group
        'xorg-xinit'            # XOrg init
        'xorg-xinput'           # Xorg xinput
        'mesa'                  # Open source version of OpenGL

    # --- Setup Qtile
        'qtile'                 # Qtile Window Manager
#        'xfce4-power-manager'  # Power Manager 
        'rofi'                  # Menu System
        'picom'                 # Translucent Windows
        'xclip'                 # System Clipboard
#        'gnome-polkit'         # Elevate Applications
        'lxappearance'          # Set System Themes
        'python-iwlib'
        'python-pip'
        'python-pyalsa'

    # --- Login Display Manager
        'lightdm'                   # Base Login Manager
        'lightdm-webkit2-greeter'   # Framework for Awesome Login Themes

    # --- Networking Setup
#        'wpa_supplicant'            # Key negotiation for WPA wireless networks
#        'dialog'                    # Enables shell scripts to trigger dialog boxex
#        'openvpn'                   # Open VPN support
#        'networkmanager-openvpn'    # Open VPN plugin for NM
#        'network-manager-applet'    # System tray icon/utility for network connectivity
#        'libsecret'                 # Library for storing passwords
    
    # --- Audio
        'alsa-utils'        # Advanced Linux Sound Architecture (ALSA) Components https://alsa.opensrc.org/
        'alsa-plugins'      # ALSA plugins
        'pulseaudio'        # Pulse Audio sound components
        'pulseaudio-alsa'   # ALSA configuration for pulse audio
        'pavucontrol'       # Pulse Audio volume control
#        'pnmixer'           # System tray volume control

    # --- Bluetooth
 #       'bluez'                 # Daemons for the bluetooth protocol stack
 #       'bluez-utils'           # Bluetooth development and debugging utilities
 #       'bluez-firmware'        # Firmwares for Broadcom BCM203x and STLC2300 Bluetooth chips
 #       'blueberry'             # Bluetooth configuration tool
 #       'pulseaudio-bluetooth'  # Bluetooth support for PulseAudio
    
    # --- Printers
        'cups'                  # Open source printer drivers
        'cups-pdf'              # PDF support for cups
#        'ghostscript'           # PostScript interpreter
        'gsfonts'               # Adobe Postscript replacement fonts
        'hplip'                 # HP Drivers
        'system-config-printer' # Printer setup  utility

    # --- Fonts
        'ttf-mononoki'
        'ttf-roboto'
        'otf-font-awesome'
        'noto-fonts'

    # --- Utils
        'htop'
        'neofetch'
        'thunar'
        'thunar-volman'
        'micro'
    
    # --- Laptop Specific
        'acpi'             # For battery
        'brightnessctl'    # Used for Brightness keyboard control
        'tlp'              # Power Management
        'tlp-rdw'          # Same for radio
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo '------------------'
echo
echo "If you have an Nvidia card, prefer installing the proprietary driver !"
echo 
echo "DONE."
