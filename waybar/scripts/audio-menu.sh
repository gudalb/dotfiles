#!/bin/bash

# Get available sinks
sinks=$(pactl list short sinks | awk '{print $2 " " $1}')
current=$(pactl info | grep "Default Sink" | cut -d' ' -f3)

# Create menu options
options=""
while IFS= read -r line; do
    sink_name=$(echo "$line" | cut -d' ' -f1)
    sink_id=$(echo "$line" | cut -d' ' -f2)

    # Get friendly name
    friendly_name=$(pactl list sinks | grep -A1 "Name: $sink_name" | grep "Description:" | cut -d':' -f2 | sed 's/^ *//')

    if [ "$sink_name" = "$current" ]; then
        options="$options● $friendly_name\n"
    else
        options="$options○ $friendly_name\n"
    fi
done <<<"$sinks"

# Show menu with wofi/rofi
selected=$(echo -e "$options" | wofi --dmenu --prompt "Select Audio Device")

if [ -n "$selected" ]; then
    # Extract device name and set as default
    device_name=$(echo "$selected" | sed 's/^[●○] //')
    sink_name=$(pactl list sinks | grep -B1 "Description: $device_name" | grep "Name:" | cut -d' ' -f2)
    pactl set-default-sink "$sink_name"
fi
