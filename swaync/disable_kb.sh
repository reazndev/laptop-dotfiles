#!/bin/bash

DEVICE="1:1:AT_Translated_Set_2_keyboard"

# 1. Get the current status of "send_events" using jq
# If the keyboard is enabled, this usually returns "enabled" or "null"
# If disabled, it returns "disabled"
STATUS=$(swaymsg -t get_inputs | jq -r ".[] | select(.identifier == \"$DEVICE\") | .libinput.send_events")

# 2. Toggle logic
if [ "$STATUS" == "disabled" ]; then
    swaymsg input "$DEVICE" events enabled
    notify-send -t 2000 "Keyboard" "Enabled"
else
    swaymsg input "$DEVICE" events disabled
    notify-send -t 2000 "Keyboard" "Disabled"
fi