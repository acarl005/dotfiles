#!/usr/bin/env python3

import subprocess
import gi
import sys
from pathlib import Path

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

# Power menu entries: display name -> (icon name, command)
POWER_ACTIONS = {
    "Lock": ("system-lock-screen-symbolic", "loginctl lock-session"),
    "Logout": ("system-log-out-symbolic", "hyprctl dispatch exit"),
    "Power Off": ("system-shutdown-symbolic", "systemctl poweroff"),
    "Reboot": ("system-reboot-symbolic", "systemctl reboot"),
    "Suspend": ("media-playback-pause-symbolic", "systemctl suspend"),
}

icon_theme = Gtk.IconTheme.get_default()

menu_items = []
for display_name, (icon_name, _) in POWER_ACTIONS.items():
    icon_info = icon_theme.lookup_icon(icon_name, 48, Gtk.IconLookupFlags.GENERIC_FALLBACK)
    if icon_info is None:
        print(f"Warning: Could not find icon '{icon_name}'", file=sys.stderr)
        icon_path = "/usr/share/icons/AdwaitaLegacy/48x48/mimetypes/application-x-executable.png"
    else:
        icon_path = icon_info.get_filename()
    menu_items.append(f"img:{icon_path}:text:{display_name}")

# Show menu
try:
    wofi_input = "\n".join(menu_items)
    choice = subprocess.run(
        ["wofi", "--conf", str(Path.home() / ".config/wofi/power_menu.conf")],
        input=wofi_input,
        text=True,
        capture_output=True,
        check=True
    ).stdout.strip()
except subprocess.CalledProcessError:
    sys.exit(1) # User exited wofi

# Parse result
if not choice:
    sys.exit(0)

selected_name = choice.split(":text:", 1)[-1]

# Run associated command
if selected_name in POWER_ACTIONS:
    command = POWER_ACTIONS[selected_name][1]
    subprocess.run(command, shell=True)
