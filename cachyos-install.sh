#!/usr/bin/env bash

set -e

echo "Starting CachyOS software installation..."
echo "Note: Packages already installed will be skipped automatically"
echo ""

if ! command -v pacman &> /dev/null; then
    echo "Error: This script requires pacman (Arch-based system)"
    exit 1
fi

if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    echo "Warning: No AUR helper found. Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    AUR_HELPER="yay"
fi

echo "Using AUR helper: $AUR_HELPER"

PACKAGES=(
    # UI and system
    fuzzel
    mako

    # Terminals
    wezterm

    # Editors
    neovim
    vim

    # Terminal utilities
    yazi
    htop
    fzf

    # Screenshots and clipboard
    grim
    wl-clipboard

    # Screen locking and idle
    swayidle
    swaylock

    # System utilities (some likely already installed)
    p7zip
    pavucontrol
    wget
    unzip
    parted

    # Browser
    firefox

    # Gaming platforms
    bottles
    lutris
    steam

    # Gaming communication
    discord

    # Wine and compatibility layers
    wine-staging
    winetricks
    dxvk
    gamemode
    mangohud
    lib32-gamemode

    # Gaming libraries (most likely already installed)
    glibc
    lib32-glibc
    libglvnd
    lib32-libglvnd
    mesa
    lib32-mesa
    vulkan-icd-loader
    lib32-vulkan-icd-loader
    vulkan-tools

    # Development tools
    gcc
    make
    pkg-config
    lazygit
    k9s
    jq
    go
    appimage-run

    # Kubernetes tools
    kubectl

    # Media
    mpv
    ffmpeg
    qbittorrent
    spotify-launcher

    # System utilities (likely already installed)
    bluez
    bluez-utils
    blueman
    networkmanager
    openssh
)

# AUR packages
AUR_PACKAGES=(
    protonplus
    protonvpn-gui
    claude-code
    dbeaver
    azure-cli
    kubelogin-bin
    protontricks
)

# Install official repository packages
echo "Installing packages from official repositories..."
echo "(Already installed packages will be skipped)"
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# Install AUR packages
echo ""
echo "Installing AUR packages..."
echo "(Already installed packages will be skipped)"
$AUR_HELPER -S --needed --noconfirm "${AUR_PACKAGES[@]}"

# Install .NET SDK
echo "Installing .NET SDK..."
$AUR_HELPER -S --needed --noconfirm dotnet-sdk-8.0 dotnet-sdk-9.0 dotnet-sdk
$AUR_HELPER -S --needed --noconfirm dotnet-ef

# Install Node.js
echo "Installing Node.js..."
sudo pacman -S --needed --noconfirm nodejs npm

# Install Python with common packages
echo "Installing Python..."
sudo pacman -S --needed --noconfirm python python-pip python-requests

# Enable and start services (if not already enabled)
echo ""
echo "Enabling services..."
sudo systemctl enable sddm 2>/dev/null || echo "  sddm already enabled"
sudo systemctl enable bluetooth 2>/dev/null || echo "  bluetooth already enabled"
sudo systemctl enable NetworkManager 2>/dev/null || echo "  NetworkManager already enabled"

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Run the symlink script to setup config files: ./setup-symlinks.sh"
echo "2. Reboot your system"
echo "3. Select Hyprland from the SDDM session menu"
