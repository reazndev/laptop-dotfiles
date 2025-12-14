#!/bin/bash

ZEN_GAP=500
DEFAULT_GAP=0

current_ws=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused).name')

lock_file="/tmp/sway_gaps_toggle_${current_ws}.lock"

if [ -f "$lock_file" ]; then
    # Toggle OFF: Go back to default and remove the lock file
    swaymsg gaps horizontal current set $DEFAULT_GAP
    rm "$lock_file"
else
    # Toggle ON: Set the zen gaps and create the lock file
    swaymsg gaps horizontal current set $ZEN_GAP
    touch "$lock_file"
fi
