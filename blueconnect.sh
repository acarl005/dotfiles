#!/bin/bash

devices=$(bluetoothctl devices 2>/dev/null | grep '^Device')

if [[ -z "$devices" ]]; then
    echo "No paired devices found."
    exit 1
fi

# Present interactive selector
selection=$(echo "$devices" | fzf --prompt "Select Bluetooth device: ")

if [[ -z "$selection" ]]; then
    echo "No selection made."
    exit 1
fi

# Extract MAC address and device name
mac=$(echo "$selection" | awk '{print $2}')
name=$(echo "$selection" | awk '{for (i=3; i<=NF; i++) printf "%s%s", $i, (i<NF ? OFS : ORS)}')

echo "Connecting to $name ($mac)..."
bluetoothctl connect "$mac"

