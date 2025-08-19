#!/bin/bash

# Check if pavucontrol is already running
if pgrep -x "pavucontrol" >/dev/null; then
    # If running, kill it (toggle behavior)
    pkill pavucontrol
else
    # If not running, start it
    pavucontrol &
fi
