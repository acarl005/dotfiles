#!/bin/bash


grep closed /proc/acpi/button/lid/LID0/state 
LID_OPEN=$?
if [[ $LID_OPEN = 1 ]]; then
  exit 0
fi

readarray -t MONITOR_IDS < <(hyprctl -j monitors | jq -r '.[].id | select(. != 0)' | sort -n)
LAST_MONITOR_INDEX=$(( "${#MONITOR_IDS[@]}" - 1 ))

# Get all workspaces on the built-in monitor (assuming it has ID 0).
readarray -t WORKSPACE_IDS < <(hyprctl -j workspaces | jq -r ".[] | select(.monitorID == 0).id")

for i in "${!WORKSPACE_IDS[@]}"; do
  WORKSPACE_ID="${WORKSPACE_IDS[i]}"
  MONITOR_INDEX=$(( i > LAST_MONITOR_INDEX ? LAST_MONITOR_INDEX : i ))
  MONITOR_ID="${MONITOR_IDS[MONITOR_INDEX]}"
  hyprctl dispatch moveworkspacetomonitor "$WORKSPACE_ID" "$MONITOR_ID"
done
