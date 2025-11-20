#!/usr/bin/env bash

# Get the active window address
ACTIVE=$(hyprctl activewindow -j | jq -r '.address')

# Get all clients that are mapped (visible) but not the active window
BACKGROUND_APPS=$(hyprctl clients -j | jq -r --arg active "$ACTIVE" '
  [.[] | select(.mapped == true and .address != $active) | .class]
  | unique
  | join(", ")
')

# Count background apps
COUNT=$(hyprctl clients -j | jq --arg active "$ACTIVE" '
  [.[] | select(.mapped == true and .address != $active)] | length
')

if [ "$COUNT" -gt 0 ]; then
  # Limit display to first 3 apps if there are many
  if [ ${#BACKGROUND_APPS} -gt 50 ]; then
    SHORT_LIST=$(echo "$BACKGROUND_APPS" | cut -c1-50)
    echo "{\"text\": \"󰀹 $COUNT\", \"tooltip\": \"$BACKGROUND_APPS\", \"class\": \"background-apps\"}"
  else
    echo "{\"text\": \"󰀹 $COUNT\", \"tooltip\": \"$BACKGROUND_APPS\", \"class\": \"background-apps\"}"
  fi
else
  echo "{\"text\": \"\", \"tooltip\": \"No background apps\", \"class\": \"background-apps-empty\"}"
fi
