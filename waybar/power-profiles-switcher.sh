#!/usr/bin/env sh

# --- Define TLP actions and labels ---
MENU_ENTRIES=$(cat << EOF
󰓅 Performance | tlp ac
󰱦 Power-Saver | tlp bat
󰁹 Default | tlp start
EOF
)

# --- Generate the Vicinae dmenu list and capture user selection ---
SELECTED_LINE=$(echo "$MENU_ENTRIES" | awk -F'|' '{print $1}' | vicinae dmenu --placeholder "Select TLP Power Profile")

# --- Process Selection ---
if [ -n "$SELECTED_LINE" ]; then
    FULL_ENTRY=$(echo "$MENU_ENTRIES" | grep "^${SELECTED_LINE} |")
    COMMAND=$(echo "$FULL_ENTRY" | awk -F'|' '{print $2}' | sed 's/^[ \t]*//')

    if [ -n "$COMMAND" ]; then
        ( $COMMAND & )
        # Send Notification (as requested)
        notify-send "TLP Profile Switched" "Profile set to: ${SELECTED_LINE}" -u normal
    fi
fi