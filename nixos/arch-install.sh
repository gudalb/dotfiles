#!/bin/bash
# Arch Linux installation script for packages from NixOS configuration
# Generated from home.nix and configuration.nix

set -e

echo "Installing packages for Arch Linux..."

# Update system first
sudo pacman -Syu --noconfirm

# Wayland compositor and desktop environment
sudo pacman -S --noconfirm \
    hyprland \
    waybar \
    mako \
    fuzzel \
    sddm \
    xdg-desktop-portal-hyprland

# Terminal and editors
sudo pacman -S --noconfirm \
    kitty \
    neovim \
    vim

# Terminal utilities
sudo pacman -S --noconfirm \
    yazi \
    htop \
    p7zip \
    pavucontrol \
    wget \
    unzip \
    fzf \
    jq \
    lazygit

# Screenshots and clipboard (Wayland)
sudo pacman -S --noconfirm \
    grim \
    slurp \
    wl-clipboard

# Screen locking and idle management
sudo pacman -S --noconfirm \
    swayidle \
    swaylock

# Blue light filter
sudo pacman -S --noconfirm \
    gammastep

# Disk mounting
sudo pacman -S --noconfirm \
    udiskie \
    udisks2

# Web browser
sudo pacman -S --noconfirm \
    firefox

# Gaming platforms
sudo pacman -S --noconfirm \
    bottles \
    lutris \
    steam

# Gaming communication
sudo pacman -S --noconfirm \
    discord

# Wine and compatibility layers
sudo pacman -S --noconfirm \
    wine-staging \
    wine-mono \
    wine-gecko \
    winetricks

# Gaming performance tools
sudo pacman -S --noconfirm \
    gamemode \
    lib32-gamemode \
    mangohud \
    lib32-mangohud

# Gaming libraries
sudo pacman -S --noconfirm \
    glib2 \
    lib32-glib2 \
    glibc \
    lib32-glibc \
    mesa \
    lib32-mesa \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    vulkan-tools

# Development tools and compilers
sudo pacman -S --noconfirm \
    gcc \
    make \
    pkg-config \
    git

# Kubernetes and cloud tools
sudo pacman -S --noconfirm \
    kubectl \
    k9s \
    azure-kubelogin \
    go

# Databases
sudo pacman -S --noconfirm \
    dbeaver

# Multimedia
sudo pacman -S --noconfirm \
    qbittorrent \
    mpv \
    ffmpeg \
    calibre

# Utilities
sudo pacman -S --noconfirm \
    kcalc \
    blueman \
    bluez \
    bluez-utils

# Development runtimes
sudo pacman -S --noconfirm \
    dotnet-sdk \
    aspnet-runtime \
    nodejs \
    npm \
    python \
    python-requests

# Fonts
sudo pacman -S --noconfirm \
    ttf-font-awesome \
    ttf-firacode-nerd \
    ttf-jetbrains-mono-nerd \
    noto-fonts \
    noto-fonts-emoji \
    ttf-liberation \
    ttf-dejavu

# Enable multilib repository for 32-bit support (gaming)
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo ""
    echo "Enabling multilib repository for 32-bit library support..."
    sudo sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
    sudo pacman -Syu --noconfirm
fi

# AUR helper (yay) installation
if ! command -v yay &> /dev/null; then
    echo ""
    echo "Installing yay AUR helper..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# AUR packages
echo ""
echo "Installing AUR packages..."

yay -S --noconfirm \
    protontricks \
    azure-cli \
    protonvpn-gui \
    spotify \
    protonplus \
    claude-code

# Additional notes:
echo ""
echo "==============================================="
echo "Installation notes:"
echo "==============================================="
echo "1. .NET SDK 9.0 - Arch may have older version in repos"
echo "   Check current version with: dotnet --list-sdks"
echo ""
echo "2. DXVK is included with wine-staging and Proton"
echo ""
echo "3. ProtonPlus - Alternative installation via Flatpak if AUR fails:"
echo "   flatpak install flathub com.vysp3r.ProtonPlus"
echo ""
echo "4. Claude Code may require disabling auto-updates:"
echo "   claude config set -g autoUpdates disabled"
echo ""
echo "==============================================="
echo "Post-installation steps:"
echo "==============================================="
echo "1. Enable and start bluetooth:"
echo "   sudo systemctl enable bluetooth && sudo systemctl start bluetooth"
echo ""
echo "2. Enable gamemode:"
echo "   systemctl --user enable gamemoded && systemctl --user start gamemoded"
echo ""
echo "3. Enable SDDM:"
echo "   sudo systemctl enable sddm"
echo ""
echo "4. Configure SDDM to use Wayland session"
echo ""
echo "5. Set up Hyprland configuration from home.nix"
echo ""
echo "6. Enable Steam Play (Proton) in Steam settings for Windows games"
echo ""
echo "7. For AppImage support, install:"
echo "   yay -S appimagekit"
echo ""
