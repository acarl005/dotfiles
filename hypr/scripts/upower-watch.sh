#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-upower-watch.lock"
exec 9>"$LOCK_FILE"
flock -n 9 || exit 0

"$SCRIPT_DIR/upower-sync.sh"

gdbus monitor --system \
  --dest org.freedesktop.UPower \
  --object-path /org/freedesktop/UPower 2>/dev/null |
while IFS= read -r line; do
  case "$line" in
    *"'OnBattery': <true>"*)
      hyprctl eval 'require("power").set_on_battery(true)' >/dev/null 2>&1
      ;;
    *"'OnBattery': <false>"*)
      hyprctl eval 'require("power").set_on_battery(false)' >/dev/null 2>&1
      ;;
  esac
done
