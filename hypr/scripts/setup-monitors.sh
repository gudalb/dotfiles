#!/bin/bash
if hyprctl monitors | grep -q "eDP-1"; then
    # Laptop setup
    hyprctl keyword monitor "eDP-1,highrr,auto,1.25"
    hyprctl keyword monitor ",preferred,auto,1"
else
    # Desktop setup
    hyprctl keyword monitor ",highrr,auto,auto"
fi
