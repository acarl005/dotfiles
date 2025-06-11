#!/bin/bash

set -e

DISPLAY_NAMES=(Lock Logout 'Power Off' Reboot Suspend)
COMMANDS=('loginctl lock-session' 'hyprctl dispatch exit' 'systemctl poweroff' 'systemctl reboot' 'systemctl suspend')
ICON_PATHS=(
  /usr/share/icons/Adwaita/symbolic/status/system-lock-screen-symbolic.svg
  /usr/share/icons/Adwaita/symbolic/actions/system-log-out-symbolic.svg
  /usr/share/icons/Adwaita/symbolic/actions/system-shutdown-symbolic.svg
  /usr/share/icons/Adwaita/symbolic/actions/system-reboot-symbolic.svg
  /usr/share/icons/Adwaita/symbolic/actions/media-playback-pause-symbolic.svg
)

MENU_ITEMS=()
for i in "${!DISPLAY_NAMES[@]}"; do
  MENU_ITEMS+=("img:${ICON_PATHS[i]}:text:${DISPLAY_NAMES[i]}")
done

CHOICE=$(printf '%s\n' "${MENU_ITEMS[@]}" | wofi --conf ~/.config/wofi/power_menu.conf)

# Extract label from `text:...`
SELECTED_NAME="${CHOICE#*:text:}"

# Match selection and run command
for i in "${!DISPLAY_NAMES[@]}"; do
  if [[ "${DISPLAY_NAMES[i]}" == "$SELECTED_NAME" ]]; then
    eval "${COMMANDS[i]}"
    break
  fi
done
