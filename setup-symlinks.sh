#!/usr/bin/env bash

# Config Symlink Setup Script
# Creates symlinks from dotfiles to ~/.config

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "Setting up symlinks from $SCRIPT_DIR to $CONFIG_DIR"

# Ensure .config directory exists
mkdir -p "$CONFIG_DIR"

# List of config directories to symlink
declare -A CONFIGS=(
    ["nvim"]="nvim"
    ["hyprland"]="hypr"
    ["mpv"]="mpv"
    ["kitty"]="kitty"
    ["mako"]="mako"
    ["swaylock"]="swaylock"
    ["waybar"]="waybar"
    ["wofi"]="wofi"
    ["yazi"]="yazi"
)

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"

    if [ -L "$target" ]; then
        echo "  Removing existing symlink: $target"
        rm "$target"
    elif [ -e "$target" ]; then
        echo "  Backing up existing config: $target -> $target.backup"
        mv "$target" "$target.backup"
    fi

    echo "  Creating symlink: $target -> $source"
    ln -s "$source" "$target"
}

# Create symlinks for each config
for config_name in "${!CONFIGS[@]}"; do
    source_dir="$SCRIPT_DIR/${CONFIGS[$config_name]}"
    target_dir="$CONFIG_DIR/$config_name"

    if [ ! -d "$source_dir" ]; then
        echo "Warning: Source directory not found: $source_dir"
        continue
    fi

    echo "Setting up $config_name..."
    create_symlink "$source_dir" "$target_dir" "$config_name"
done

echo ""
echo "Symlink setup complete!"
echo ""
echo "The following directories are now symlinked:"
for config_name in "${!CONFIGS[@]}"; do
    target_dir="$CONFIG_DIR/$config_name"
    if [ -L "$target_dir" ]; then
        echo "  $config_name: $(readlink "$target_dir")"
    fi
done

echo ""
echo "Note: Any existing configs were backed up with a .backup extension"
