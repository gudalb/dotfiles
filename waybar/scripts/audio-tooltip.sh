#!/bin/bash

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n1 | awk '{print $5}' | sed 's/%//')
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
current_sink=$(pactl info | grep "Default Sink" | cut -d' ' -f3)

# Build tooltip with device list
tooltip="Current: $(pactl list sinks | grep -A1 "Name: $current_sink" | grep "Description:" | cut -d':' -f2 | sed 's/^ *//')\n\nAvailable Devices:\n"

while IFS= read -r line; do
    sink_name=$(echo "$line" | cut -d' ' -f2)
    friendly_name=$(pactl list sinks | grep -A1 "Name: $sink_name" | grep "Description:" | cut -d':' -f2 | sed 's/^ *//')

    if [ "$sink_name" = "$current_sink" ]; then
        tooltip="$tooltip● $friendly_name\n"
    else
        tooltip="$tooltip○ $friendly_name\n"
    fi
done <<<"$(pactl list short sinks)"

tooltip="$tooltip\nLeft click: Open pavucontrol\nRight click: Select device"

# Output JSON
if [ "$muted" = "yes" ]; then
    echo "{\"text\": \"  $volume%\", \"tooltip\": \"$tooltip\", \"class\": \"muted\"}"
else
    if [ "$volume" -ge 70 ]; then icon=" "; elif [ "$volume" -ge 30 ]; then icon=" "; else icon=" "; fi
    echo "{\"text\": \"$icon  $volume%\", \"tooltip\": \"$tooltip\", \"class\": \"normal\"}"
fi
