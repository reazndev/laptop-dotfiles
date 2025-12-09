#!/usr/bin/env sh

# Check the 'Mode' field from the concise TLP status output.
TLP_MODE=$(tlp-stat | grep "Mode" | awk '{print $3}')

# Check physical power connection status (still needed to differentiate TLP's default/ac behavior)
AC_ONLINE=$(cat /sys/class/power_supply/AC*/online 2>/dev/null | head -n 1)

# --- Determine the Mode to Display ---

if [ "$AC_ONLINE" = "1" ]; then
    # Physically connected to AC (Performance)
    echo "TLP:  Performance"
    
elif [ "$TLP_MODE" = "battery" ]; then
    # Unplugged, and TLP is reporting its battery profile is active (Power-Saver)
    echo "TLP: 󰱦 Power-Saver"
    
elif [ "$TLP_MODE" = "ac" ]; then
    # Unplugged, but TLP is reporting its AC profile is still active
    # This means the user has manually set 'tlp ac' or TLP hasn't fully switched.
    echo "TLP: 󰓅 Performance (Unplugged)"
    
else
    # Fallback / Unknown state
    echo "TLP: 󰁹 Default"
fi