#!/bin/bash

# Requires: jq, ps, find, grep, xdg-mime

# Get window clients from hyprctl
clients=$(hyprctl -j clients)

echo "$clients" | jq -c '.[]' | while read -r client; do
    workspace_id=$(echo "$client" | jq -r '.workspace.id')
    class=$(echo "$client" | jq -r '.class')
    pid=$(echo "$client" | jq -r '.pid')
    title=$(echo "$client" | jq -r '.title')
    address=$(echo "$client" | jq -r '.address')

    # Get executable from PID
    exe=$(readlink /proc/"$pid"/exe 2>/dev/null)
    if [ -z "$exe" ]; then
        continue
    fi
    bin=$(basename "$exe")

    # Try to find a matching .desktop file
    desktop=$(grep -rl "Exec=.*$bin" /usr/share/applications ~/.local/share/applications 2>/dev/null | head -n1)

    if [ -z "$desktop" ]; then
        continue
    fi

    # Extract icon name
    icon_name=$(grep -i '^Icon=' "$desktop" | cut -d= -f2)
    if [ -z "$icon_name" ]; then
        continue
    fi

    # Resolve icon path
    # icon_path=$(find /usr/share/icons ~/.icons ~/.local/share/icons -type f \( -iname "$icon_name.png" -o -iname "$icon_name.svg" -o -iname "$icon_name.xpm" \) 2>/dev/null | head -n1)
    # Find PNG or XPM files (skip SVG)
    mapfile -t icons < <(find /usr/share/icons ~/.icons ~/.local/share/icons \
        -type f \( -iname "$icon_name.png" -o -iname "$icon_name.xpm" \) 2>/dev/null)

    if [ "${#icons[@]}" -eq 0 ]; then
        echo "$class   $title @ $address"
        continue
    fi

    # Pick the one with largest size from path (e.g., "128x128")
    icon_path=$(printf '%s\n' "${icons[@]}" | awk '
        function size(s) {
            match(s, /\/([0-9]+)x[0-9]+\//, a)
            return a[1] ? a[1] : 0
        }
        { print size($0), $0 }
    ' | sort -nr | head -n1 | cut -d' ' -f2-)

    echo "img:$icon_path:text:$class   $title @ $address"
done
