#!/bin/bash
# Fedora installation script for packages from NixOS configuration
# Generated from home.nix and configuration.nix

set -e

echo "Installing packages for Fedora..."

# Enable RPM Fusion repositories (required for many packages)
sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Wayland compositor and desktop environment
sudo dnf install -y \
    hyprland \
    waybar \
    mako \
    fuzzel \
    sddm \
    sddm-wayland-sway

# Terminal and editors
sudo dnf install -y \
    kitty \
    neovim \
    vim

# Terminal utilities
sudo dnf install -y \
    yazi \
    htop \
    p7zip \
    p7zip-plugins \
    pavucontrol \
    wget \
    unzip \
    fzf \
    jq \
    lazygit

# Screenshots and clipboard (Wayland)
sudo dnf install -y \
    grim \
    slurp \
    wl-clipboard

# Screen locking and idle management
sudo dnf install -y \
    swayidle \
    swaylock

# Blue light filter
sudo dnf install -y \
    gammastep

# Disk mounting
sudo dnf install -y \
    udiskie \
    udisks2

# Web browser
sudo dnf install -y \
    firefox

# Gaming platforms
sudo dnf install -y \
    bottles \
    lutris \
    steam

# Gaming communication
sudo dnf install -y \
    discord

# Wine and compatibility layers
sudo dnf install -y \
    wine \
    wine-dxvk \
    wine-dxvk-d3d9 \
    wine-dxvk-dxgi \
    winetricks \
    protontricks

# Gaming performance tools
sudo dnf install -y \
    gamemode \
    mangohud

# Gaming libraries
sudo dnf install -y \
    glib2 \
    glibc \
    mesa-libGL \
    mesa-libGLU \
    mesa-vulkan-drivers \
    vulkan-tools \
    vulkan-loader

# Development tools and compilers
sudo dnf install -y \
    gcc \
    gcc-c++ \
    make \
    pkg-config \
    git

# Kubernetes and cloud tools
sudo dnf install -y \
    kubectl \
    golang

# Enable Azure CLI repository
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo

sudo dnf install -y azure-cli

# Databases - Install DBeaver
sudo dnf install -y java-21-openjdk
wget -O /tmp/dbeaver-ce-latest-stable.x86_64.rpm https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm
sudo dnf install -y /tmp/dbeaver-ce-latest-stable.x86_64.rpm

# Multimedia
sudo dnf install -y \
    qbittorrent \
    mpv \
    ffmpeg \
    ffmpeg-free

# Utilities
sudo dnf install -y \
    kcalc \
    blueman

# Development runtimes
sudo dnf install -y \
    dotnet-sdk-8.0 \
    dotnet-sdk-9.0 \
    nodejs \
    python3 \
    python3-requests

# Fonts
sudo dnf install -y \
    fontawesome-fonts \
    fira-code-fonts \
    jetbrains-mono-fonts \
    noto-fonts \
    noto-fonts-emoji \
    liberation-fonts \
    dejavu-fonts

# Additional tools via COPR and third-party repos
echo ""
echo "Installing k9s from COPR repository..."
sudo dnf copr enable -y luminoso/k9s
sudo dnf install -y k9s

# Calibre
sudo dnf install -y calibre

# ProtonVPN GUI
echo ""
echo "Installing ProtonVPN..."
wget -O /tmp/protonvpn-stable-release.rpm https://repo.protonvpn.com/fedora-$(rpm -E %fedora)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm
sudo dnf install -y /tmp/protonvpn-stable-release.rpm
sudo dnf check-update --refresh
sudo dnf install -y proton-vpn-gnome-desktop

# Spotify via RPM Fusion lpf
echo ""
echo "Installing Spotify..."
sudo dnf install -y lpf-spotify-client
# Note: After installation, run 'lpf update' to approve the license and build Spotify

# Claude Code
echo ""
echo "Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

# Additional packages that may need manual installation:
echo ""
echo "==============================================="
echo "Manual/Alternative installation options:"
echo "==============================================="
echo "1. kubelogin - Install with Go:"
echo "   go install github.com/Azure/kubelogin/cmd/kubelogin@latest"
echo ""
echo "2. Spotify - After installation, run: lpf update"
echo "   This will prompt you to approve the license and build Spotify"
echo ""
echo "3. ProtonPlus - Install via Flatpak:"
echo "   flatpak install flathub com.vysp3r.ProtonPlus"
echo ""
echo "==============================================="
echo "Post-installation steps:"
echo "==============================================="
echo "1. Enable gamemode: systemctl --user enable gamemoded && systemctl --user start gamemoded"
echo "2. Configure SDDM to use Wayland session"
echo "3. Set up Hyprland configuration from home.nix"
echo "4. Install AppImage support if needed: sudo dnf install fuse fuse-libs"
echo ""
