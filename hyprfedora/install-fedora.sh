#!/bin/bash
# Fedora Installation Script for Hyprland Setup
# This script installs all required programs for the Hyprland configuration

set -e

echo "=========================================="
echo "Hyprland Fedora Installation Script"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root"
    exit 1
fi

echo "Updating system..."
sudo dnf update -y

echo ""
echo "Installing Hyprland and core Wayland components..."
# Hyprland and Wayland core
sudo dnf install -y hyprland \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    qt5-qtwayland \
    qt6-qtwayland

echo ""
echo "Installing status bar and notification daemon..."
# Waybar and Mako
sudo dnf install -y waybar \
    mako \
    font-awesome-fonts

echo ""
echo "Installing terminal and core utilities..."
# Terminal
sudo dnf install -y kitty

echo ""
echo "Installing text editors..."
# Editors
sudo dnf install -y neovim vim

echo ""
echo "Installing file manager..."
# File manager
sudo dnf install -y yazi

echo ""
echo "Installing application launcher..."
# Application launcher
sudo dnf install -y fuzzel

echo ""
echo "Installing screenshot and clipboard utilities..."
# Screenshots and clipboard
sudo dnf install -y grim \
    slurp \
    wl-clipboard

echo ""
echo "Installing screen lock and idle management..."
# Screen locking and idle management
sudo dnf install -y swaylock \
    swayidle

echo ""
echo "Installing web browser..."
# Web browser
sudo dnf install -y firefox

echo ""
echo "Installing audio control..."
# Audio
sudo dnf install -y pavucontrol \
    pipewire \
    pipewire-pulseaudio \
    wireplumber

echo ""
echo "Installing additional utilities..."
# Additional utilities
sudo dnf install -y htop \
    wget \
    unzip \
    p7zip \
    fzf

echo ""
echo "Installing fonts..."
# Fonts
sudo dnf install -y google-roboto-fonts \
    dejavu-sans-fonts \
    dejavu-serif-fonts \
    dejavu-sans-mono-fonts

echo ""
echo "=========================================="
echo "Installation complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Copy the Hyprland config to ~/.config/hyprland/"
echo "   mkdir -p ~/.config/hyprland"
echo "   cp hyprland.conf ~/.config/hyprland/"
echo ""
echo "2. Copy the Waybar config to ~/.config/waybar/"
echo "   mkdir -p ~/.config/waybar"
echo "   cp waybar/config.json ~/.config/waybar/"
echo "   cp waybar/style.css ~/.config/waybar/"
echo ""
echo "3. Log out and select Hyprland from your display manager"
echo ""
echo "Optional configurations:"
echo "- Adjust keyboard layout in hyprland.conf (currently set to 'se')"
echo "- Customize waybar colors in waybar/style.css"
echo "- Add wallpaper with tools like swaybg or hyprpaper"
echo ""
