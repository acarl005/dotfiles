#!/usr/bin/env python

import json
import subprocess
import os
import re
from pathlib import Path

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk


def get_icon_path(icon_name):
    theme = Gtk.IconTheme.get_default()
    for size in [256, 128, 64, 48, 32, 24, 16]:
        info = theme.lookup_icon(icon_name, size, 0)
        if info:
            return info.get_filename()
    return None


def get_clients():
    result = subprocess.run(["hyprctl", "-j", "clients"], capture_output=True, text=True, check=True)
    return json.loads(result.stdout)


def find_desktop_file(binary):
    search_dirs = [
        Path("/usr/share/applications"),
        Path.home() / ".local/share/applications"
    ]
    for directory in search_dirs:
        if not directory.exists():
            continue
        for path in directory.glob("*.desktop"):
            try:
                with open(path, encoding="utf-8", errors="ignore") as f:
                    for line in f:
                        if line.startswith("Exec=") and re.search(rf'\b{re.escape(binary)}\b', line):
                            return path
            except Exception:
                pass
    return None


def get_icon_name_from_desktop(path):
    with open(path, encoding="utf-8", errors="ignore") as f:
        for line in f:
            if line.lower().startswith("icon="):
                return line.strip().split("=", 1)[1]
    return None


def main():
    clients = get_clients()
    for client in clients:
        pid = client.get("pid")
        title = client.get("title")
        class_ = client.get("class")
        address = client.get("address")

        exe_path = f"/proc/{pid}/exe"
        if not os.path.exists(exe_path):
            continue

        try:
            bin_name = os.path.basename(os.readlink(exe_path))
        except OSError:
            continue

        desktop_file = find_desktop_file(bin_name)
        if not desktop_file:
            continue

        icon_name = get_icon_name_from_desktop(desktop_file)
        if not icon_name:
            continue

        icon_path = get_icon_path(icon_name)
        if icon_path:
            print(f"img:{icon_path}:text:{class_}   {title} @ {address}")
        else:
            print(f"{class_}   {title} @ {address}")


if __name__ == "__main__":
    main()
