#!/bin/bash

# --- 1. SET VOLUME ---
if [[ "$1" == "up" ]]; then
    # pamixer INCREASES volume. By default, it will NOT go past 100%.
    pamixer --increase 5
elif [[ "$1" == "down" ]]; then
    # We explicitly allow boost to ensure it can decrease volume even if it's currently > 100%
    pamixer --decrease 5 --allow-boost
elif [[ "$1" == "mute" ]]; then
    pamixer --toggle-mute
    # OR: pactl set-sink-mute @DEFAULT_SINK@ toggle
elif [[ "$1" == "mic-mute" ]]; then
    pamixer --default-source --toggle-mute
    # OR: pactl set-source-mute @DEFAULT_SOURCE@ toggle
fi

# --- 2. GET STATUS & VOLUME (using pamixer) ---
# Get the current volume level
VOLUME=$(pamixer --get-volume)
# Check if the primary sink is muted
IS_MUTED=$(pamixer --get-mute)

# --- 3. DETERMINE ICON & MESSAGE ---
# ... (The rest of the icon and message logic remains the same)
ICON="audio-volume-high"
MESSAGE="Volume: ${VOLUME}%"
URGENCY="low"

if [[ "$IS_MUTED" == "true" ]]; then
    ICON="audio-volume-muted"
    MESSAGE="Muted"
    URGENCY="low"
elif [[ "$VOLUME" -lt 1 ]]; then
    ICON="audio-volume-off"
elif [[ "$VOLUME" -lt 33 ]]; then
    ICON="audio-volume-low"
elif [[ "$VOLUME" -lt 67 ]]; then
    ICON="audio-volume-medium"
else
    ICON="audio-volume-high"
fi

# --- 4. SEND NOTIFICATION ---
notify-send \
    -u "${URGENCY}" \
    -i "${ICON}" \
    -h "int:value:${VOLUME}" \
    -h "string:x-canonical-private-synchronous:volume_notif" \
    "${MESSAGE}"