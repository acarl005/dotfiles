#!/bin/bash

declare -A ICONS
ICONS["firefox"]="󰈹 "
ICONS["google-chrome"]=" "
ICONS["glide-glide"]=" "
ICONS["kitty"]=" "
ICONS["com.mitchellh.ghostty"]=" "
ICONS["dev.warp.Warp"]=" "
ICONS["dev.warp.WarpDev"]=" "
ICONS["org.kde.dolphin"]=" "
ICONS["thunar"]=" "
ICONS["xdg-desktop-portal-gtk"]=" "
ICONS["Cursor"]="󰆧 "
ICONS["Spotify"]=" "
ICONS["vlc"]="󰕼 "
ICONS["virt-viewer"]="󰍹 "
ICONS["remote-viewer"]="󰍹 "
ICONS["1Password"]="󰯅 "
ICONS["1password"]="󰯅 "
ICONS["qdbusviewer"]=" "
ICONS["mpv"]=" "
ICONS["qvidcap"]=" "
ICONS["com.obsproject.Studio"]=" "
ICONS["Audacity"]=" "
ICONS["blueman-manager"]=" "
ICONS["kbd-layout-viewer"]=" "
ICONS["neovide"]=" "
ICONS["io.missioncenter.MissionCenter"]=" "
ICONS["Slack"]=" "

handle() {
  # Chop off event name and split comma-delimited args to an array.
  IFS=',' read -ra FIELDS <<< "${1#*>>}"
  case $1 in
    # monitoraddedv2*)
    #   grep closed /proc/acpi/button/lid/LID0/state 
    #   LID_OPEN=$?
    #   if [[ $LID_OPEN = 1 ]]; then
    #     return
    #   fi
    #   MONITOR_ID="${FIELDS[0]}"
    #
    #   # Wait for Hyprland IPC to become available. It lags a lot when my thunderbolt dock is plugged in.
    #   # It errors out rather than waiting on a blocking read.
    #   for _ in {1..20}; do
    #     if hyprctl -j workspaces >/dev/null 2>&1; then
    #       break
    #     fi
    #     echo "Waiting for Hyprland IPC..."
    #     sleep 0.2
    #   done
    #
    #   # Get all workspaces on the built-in monitor (assuming it has ID 0).
    #   WORKSPACE_IDS=$(hyprctl -j workspaces | jq -r ".[] | select(.monitorID == 0) | .id")
    #   for WORKSPACE_ID in $WORKSPACE_IDS; do
    #     hyprctl dispatch moveworkspacetomonitor "$WORKSPACE_ID" "$MONITOR_ID"
    #   done
    #   ;;
    activewindowv2*|openwindow*|windowtitlev2*)
      if [[ "${#FIELDS[@]}" = 0 ]]; then
        return
      fi
      CHANGED_WINDOW_ADDR="${FIELDS[0]}"
      CHANGED_WINDOW=$(get_window_by_addr "0x$CHANGED_WINDOW_ADDR")
      WORKSPACE_ID=$(echo "$CHANGED_WINDOW" | jq -r '.workspace.id')
      if [[ -n "$WORKSPACE_ID" ]]; then
        update_workspace_name "$WORKSPACE_ID"
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

# Custom naming for each workspace based on the last active window. The name will be as follows:
# - If the last active window (in the workspace) has an icon entry in the `ICONS` map, use that icon.
# - If any window in the workspace has an icon entry in the `ICONS` map, use that icon.
# - If the workspace has at least one window, but none with an icon entry in the `ICONS` map, use a generic  .
# - Otherwise, name the workspace its ID.
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

to_superscript() {
  local input="$1"
  local output=""
  local -A superscript=(
    [0]='⁰' [1]='¹' [2]='²' [3]='³' [4]='⁴'
    [5]='⁵' [6]='⁶' [7]='⁷' [8]='⁸' [9]='⁹'
  )

  for (( i=0; i<${#input}; i++ )); do
    char="${input:$i:1}"
    output+="${superscript[$char]}"
  done

  echo "$output"
}

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r LINE; do handle "$LINE"; done
