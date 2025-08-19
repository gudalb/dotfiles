#!/bin/bash

icons=""
tooltip=""

# Check for Steam
if pgrep -x "steam" >/dev/null; then
    icons="$icons<span size='13000' foreground='#f5e0dc'>  </span>"
    tooltip="$tooltip Steam\\n"
fi

# Check for Discord
if pgrep -x "discord" >/dev/null; then
    icons="$icons<span size='13000' foreground='#f5e0dc'>  </span>"
    tooltip="$tooltip Discord\\n"
fi

# Check for Spotify
if pgrep -x "spotify" >/dev/null; then
    icons="$icons<span size='13000' foreground='#f5e0dc'>  </span>"
    tooltip="$tooltip Spotify\\n"
fi

# Check for other apps
if pgrep -x "firefox" >/dev/null; then
    icons="$icons<span size='13000' foreground='#f5e0dc'>  </span>"
    tooltip="$tooltip Firefox\\n"
fi

# Output JSON format
if [ -n "$icons" ]; then
    echo "{\"text\":\"$icons\", \"tooltip\":\"$tooltip\"}"
else
    echo "{\"text\":\"\", \"tooltip\":\"No background apps\"}"
fi
