#!/usr/bin/env bash

set -u

out=$(gdbus call --system \
  --dest org.freedesktop.UPower \
  --object-path /org/freedesktop/UPower \
  --method org.freedesktop.DBus.Properties.Get \
  org.freedesktop.UPower OnBattery 2>/dev/null) || exit 1

case "$out" in
  *true*) hyprctl eval 'require("power").set_on_battery(true)' >/dev/null 2>&1 ;;
  *false*) hyprctl eval 'require("power").set_on_battery(false)' >/dev/null 2>&1 ;;
esac
