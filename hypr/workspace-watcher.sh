#!/bin/bash

declare -A ICONS
ICONS["firefox"]="󰈹 "
ICONS["google-chrome"]=" "
ICONS["kitty"]=" "
ICONS["org.kde.dolphin"]=" "
ICONS["thunar"]=" "
ICONS["Cursor"]="󰆧 "
ICONS["Spotify"]=" "
ICONS["vlc"]="󰕼 "
ICONS["virt-viewer"]="󰍹 "
ICONS["remote-viewer"]="󰍹 "
ICONS["1Password"]="󰯅 "
ICONS["qdbusviewer"]=" "
ICONS["mpv"]=" "
ICONS["qvidcap"]=" "
ICONS["Audacity"]=" "
ICONS["blueman-manager"]=" "
ICONS["kbd-layout-viewer"]=" "


handle() {
  IFS=',' read -ra FIELDS <<< "${1#*>>}"
  case $1 in
    monitoraddedv2*) # 2,DP-2,BNQ BenQ SW271 A7L01657SL0
      grep closed /proc/acpi/button/lid/LID0/state 
      LID_OPEN=$?
      if [[ $LID_OPEN = 0 ]]; then
        echo "${FIELDS[@]}"
        MONITOR_ID="${FIELDS[0]}"
        WORKSPACE_IDS=$(hyprctl -j workspaces | jq -r ".[] | select(.monitorID == $MONITOR_ID) | .id")
        echo "$WORKSPACE_IDS"
        for WORKSPACE_ID in $WORKSPACE_IDS; do
          echo hyprctl dispatch moveworkspacetomonitor "$WORKSPACE_ID" "$MONITOR_ID"
          hyprctl dispatch moveworkspacetomonitor "$WORKSPACE_ID" "$MONITOR_ID"
        done
      fi
      ;;
    activewindowv2*|openwindow*|windowtitlev2*)
      if [[ "${#FIELDS[@]}" -gt 0 ]]; then
        CHANGED_WINDOW_ADDR="${FIELDS[0]}"
        CHANGED_WINDOW=$(get_window_by_addr "0x$CHANGED_WINDOW_ADDR")
        WORKSPACE_ID=$(echo "$CHANGED_WINDOW" | jq -r '.workspace.id')
        if [[ -n "$WORKSPACE_ID" ]]; then
          update_workspace_name "$WORKSPACE_ID"
        fi
      fi
      ;;
    closewindow*|movewindowv2*)
      WORKSPACE_IDS=$(hyprctl -j workspaces | jq -r '.[].id')
      for WORKSPACE_ID in $WORKSPACE_IDS; do
        update_workspace_name "$WORKSPACE_ID"
      done
      ;;
    *) ;;
  esac
}

update_workspace_name() {
  WORKSPACE_ID="$1"
  WORKSPACE=$(hyprctl -j workspaces | jq ".[] | select(.id == $WORKSPACE_ID)")
  ACTIVE_WINDOW_ADDR=$(echo "$WORKSPACE" | jq -r '.lastwindow')
  if [[ "$ACTIVE_WINDOW_ADDR" = 0x0 ]]; then
    hyprctl dispatch renameworkspace "$WORKSPACE_ID" "$WORKSPACE_ID"
    return
  fi
  ACTIVE_WINDOW=$(get_window_by_addr "$ACTIVE_WINDOW_ADDR")
  ACTIVE_WINDOW_CLASS=$(echo "$ACTIVE_WINDOW" | jq -r '.class')
  if [[ -n "${ICONS[$ACTIVE_WINDOW_CLASS]}" ]]; then
    hyprctl dispatch renameworkspace "$WORKSPACE_ID" "${ICONS[$ACTIVE_WINDOW_CLASS]}" 
    return
  fi
  ALL_WINDOWS=$(hyprctl -j clients | jq -c ".[] | select(.workspace.id == $WORKSPACE_ID)")
  if [[ -z "$ALL_WINDOWS" ]]; then
    hyprctl dispatch renameworkspace "$WORKSPACE_ID" "$WORKSPACE_ID"
    return
  fi
  while IFS= read -r WINDOW; do
    WINDOW_CLASS=$(echo "$WINDOW" | jq -r '.class')
    if [[ -n "${ICONS[$WINDOW_CLASS]}" ]]; then
      hyprctl dispatch renameworkspace "$WORKSPACE_ID" "${ICONS[$WINDOW_CLASS]}" 
      return
    fi
  done <<< "$ALL_WINDOWS"
  hyprctl dispatch renameworkspace "$WORKSPACE_ID" " "
}

get_window_by_addr() {
  hyprctl -j clients | jq ".[] | select(.address == \"$1\")"
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
