#!/usr/bin/env python3

import hashlib
import os
import subprocess
import sys
from pathlib import Path

import gi

gi.require_version("Gdk", "3.0")
gi.require_version("Gtk", "3.0")
from gi.repository import Gdk, Gtk

ICON_SIZE = 64
ICON_COLOR = "#2e3436"
FALLBACK_ICON = "/usr/share/icons/AdwaitaLegacy/48x48/mimetypes/application-x-executable.png"
CACHE_DIR = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "power_menu_icons"

POWER_ACTIONS = {
    "Suspend": ("media-playback-pause-symbolic", "systemctl suspend"),
    "Lock": ("system-lock-screen-symbolic", "loginctl lock-session"),
    "Logout": ("system-log-out-symbolic", 'hyprctl dispatch "hl.dsp.exit()"'),
    "Hibernate": ("weather-clear-night-symbolic", "systemctl hibernate"),
    "Reboot": ("system-reboot-symbolic", "systemctl reboot"),
    "Power Off": ("system-shutdown-symbolic", "systemctl poweroff"),
}


def resolve_icon(icon_theme: Gtk.IconTheme, icon_name: str, fg_color: Gdk.RGBA) -> str:
    icon_info = icon_theme.lookup_icon(
        icon_name,
        ICON_SIZE,
        Gtk.IconLookupFlags.GENERIC_FALLBACK | Gtk.IconLookupFlags.FORCE_SIZE,
    )
    if icon_info is None:
        print(f"Warning: Could not find icon '{icon_name}'", file=sys.stderr)
        return FALLBACK_ICON

    src_path = icon_info.get_filename()
    if not src_path or not src_path.endswith(".svg"):
        return src_path or FALLBACK_ICON

    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    mtime_ns = os.stat(src_path).st_mtime_ns
    cache_key = hashlib.sha256(
        f"{src_path}:{mtime_ns}:{ICON_SIZE}:{ICON_COLOR}".encode()
    ).hexdigest()[:12]
    cached_path = CACHE_DIR / f"{icon_name}-{cache_key}.png"

    if not cached_path.exists():
        pixbuf, _ = icon_info.load_symbolic(fg_color, None, None, None)
        pixbuf.savev(str(cached_path), "png", [], [])

    return str(cached_path)


def main() -> None:
    icon_theme = Gtk.IconTheme.get_default()
    fg_color = Gdk.RGBA()
    fg_color.parse(ICON_COLOR)

    menu_items = []
    for display_name, (icon_name, _) in POWER_ACTIONS.items():
        icon_path = resolve_icon(icon_theme, icon_name, fg_color)
        menu_items.append(f"img:{icon_path}:text:{display_name}")

    try:
        wofi_input = "\n".join(menu_items)
        choice = subprocess.run(
            ["wofi", "--conf", str(Path.home() / ".config/wofi/power_menu.conf")],
            input=wofi_input,
            text=True,
            capture_output=True,
            check=True,
        ).stdout.strip()
    except subprocess.CalledProcessError:
        sys.exit(1)

    if not choice:
        sys.exit(0)

    selected_name = choice.split(":text:", 1)[-1]

    if selected_name in POWER_ACTIONS:
        command = POWER_ACTIONS[selected_name][1]
        subprocess.run(command, shell=True)


if __name__ == "__main__":
    main()
