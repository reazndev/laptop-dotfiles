#!/bin/bash

# Calculate CPU Usage
# Read /proc/stat file (first line)
read cpu a b c idle rest < /proc/stat
total=$((a+b+c+idle))
sleep 0.5
read cpu a b c idle2 rest < /proc/stat
total2=$((a+b+c+idle2))
cpu_usage=$((100*( (total2-total) - (idle2-idle) ) / (total2-total) ))

# RAM Usage
mem_usage=$(free -h | awk '/^Mem/ { print $3 "/" $2 }')

# Uptime
uptime_info=$(uptime -p | sed 's/up //')

# Prepare Tooltip
tooltip="<b>  CPU:</b> ${cpu_usage}%\n<b>  RAM:</b> ${mem_usage}\n<b>󰅐  Uptime:</b> ${uptime_info}"

# Output JSON
echo "{\"tooltip\": \"$tooltip\"}"
