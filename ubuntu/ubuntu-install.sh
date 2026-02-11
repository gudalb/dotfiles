#!/usr/bin/env bash

set -e

echo "Starting Ubuntu development software installation..."
echo ""

if ! command -v apt &> /dev/null; then
    echo "Error: This script requires apt (Ubuntu/Debian-based system)"
    exit 1
fi

sudo apt update

# Terminal and editors
sudo apt install -y \
    kitty \
    neovim \
    vim

# Terminal utilities
sudo apt install -y \
    p7zip-full \
    wget \
    fzf \
    jq

# Development tools and compilers
sudo apt install -y \
    gcc \
    g++ \
    make \
    pkg-config \
    git \
    curl \
    build-essential

# Development runtimes
sudo apt install -y \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-requests

# Media
sudo apt install -y \
    mpv \
    ffmpeg

# ── .NET SDKs ───────────────────────────────────────────────────────
echo ""
echo "Installing .NET SDKs..."
if ! command -v dotnet &> /dev/null; then
    curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
    chmod +x /tmp/dotnet-install.sh
    /tmp/dotnet-install.sh --channel 8.0
    /tmp/dotnet-install.sh --channel 9.0
    /tmp/dotnet-install.sh --channel 10.0
    echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
    echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >> ~/.bashrc
    echo "  .NET SDKs installed (8.0, 9.0, 10.0)"
else
    echo "  dotnet already installed"
fi

# ── Kubectl ─────────────────────────────────────────────────────────
echo ""
echo "Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    echo "  kubectl installed"
else
    echo "  kubectl already installed"
fi

# ── Azure CLI ───────────────────────────────────────────────────────
echo ""
echo "Installing Azure CLI..."
if ! command -v az &> /dev/null; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
    echo "  Azure CLI already installed"
fi

# ── k9s ─────────────────────────────────────────────────────────────
echo ""
echo "Installing k9s..."
if ! command -v k9s &> /dev/null; then
    K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r '.tag_name')
    wget -q "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" -O /tmp/k9s.tar.gz
    sudo tar -C /usr/local/bin -xzf /tmp/k9s.tar.gz k9s
    rm /tmp/k9s.tar.gz
    echo "  k9s installed"
else
    echo "  k9s already installed"
fi

# ── lazygit ─────────────────────────────────────────────────────────
echo ""
echo "Installing lazygit..."
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r '.tag_name' | sed 's/^v//')
    wget -q "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" -O /tmp/lazygit.tar.gz
    sudo tar -C /usr/local/bin -xzf /tmp/lazygit.tar.gz lazygit
    rm /tmp/lazygit.tar.gz
    echo "  lazygit installed"
else
    echo "  lazygit already installed"
fi

# ── yazi ────────────────────────────────────────────────────────────
echo ""
echo "Installing yazi..."
if ! command -v yazi &> /dev/null; then
    YAZI_VERSION=$(curl -s https://api.github.com/repos/snakeroman/yazi/releases/latest 2>/dev/null | jq -r '.tag_name' 2>/dev/null)
    cargo install --locked yazi-fm yazi-cli
    echo "  yazi installed via cargo"
else
    echo "  yazi already installed"
fi

# ── Claude Code ─────────────────────────────────────────────────────
echo ""
echo "Installing Claude Code..."
if ! command -v claude &> /dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "  Claude Code already installed"
fi

# ── Flatpak apps ────────────────────────────────────────────────────
echo ""
echo "Installing Flatpak and apps..."
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

FLATPAK_APPS=(
    com.spotify.Client
    com.getpostman.Postman
    com.microsoft.AzureStorageExplorer
    io.dbeaver.DBeaverCommunity
    net.lutris.Lutris
    us.zoom.Zoom
)

for app in "${FLATPAK_APPS[@]}"; do
    flatpak install -y --noninteractive flathub "$app" 2>/dev/null || echo "  Failed to install $app"
done
