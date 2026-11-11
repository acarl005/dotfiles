pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../common"

Singleton {
    id: root
    property var windowList: []
    property var windowByAddress: ({})
    readonly property var sortedWindowList: {
        const list = (root.windowList ?? []).filter(w =>
            w && w.address && (w.mapped ?? true) && !(w.hidden ?? false)
            && w.title !== "quickshell-alt-tab"
            && w.initialTitle !== "quickshell-alt-tab"
            && w.class !== "org.quickshell"
            && w.class !== "quickshell"
        );
        return list.slice().sort((a, b) => {
            const focusA = Number.isFinite(a.focusHistoryID) ? a.focusHistoryID : 999999;
            const focusB = Number.isFinite(b.focusHistoryID) ? b.focusHistoryID : 999999;
            if (focusA !== focusB)
                return focusA - focusB;
            return `${a.address ?? ""}`.localeCompare(`${b.address ?? ""}`);
        });
    }
    property var monitors: []
    property bool pendingWindowsUpdate: false
    property bool pendingMonitorsUpdate: false

    function scheduleUpdates(windows, monitors) {
        pendingWindowsUpdate = pendingWindowsUpdate || !!windows;
        pendingMonitorsUpdate = pendingMonitorsUpdate || !!monitors;

        const debounceMs = Math.max(0, Config.options.hacks.hyprlandEventDebounceMs);
        if (debounceMs === 0) {
            flushPendingUpdates();
        } else {
            eventDebounceTimer.interval = debounceMs;
            eventDebounceTimer.restart();
        }
    }

    function flushPendingUpdates() {
        if (pendingWindowsUpdate) {
            pendingWindowsUpdate = false;
            getClients.running = true;
        }
        if (pendingMonitorsUpdate) {
            pendingMonitorsUpdate = false;
            getMonitors.running = true;
        }
    }

    Component.onCompleted: {
        scheduleUpdates(true, true);
        flushPendingUpdates();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            const eventName = `${event?.name ?? event?.event ?? event?.type ?? ""}`;
            if (["openlayer", "closelayer", "screencast"].includes(eventName))
                return;

            if (eventName.startsWith("monitor") || eventName === "configreloaded") {
                scheduleUpdates(true, true);
                return;
            }

            scheduleUpdates(true, false);
        }
    }

    Timer {
        id: eventDebounceTimer
        interval: Math.max(0, Config.options.hacks.hyprlandEventDebounceMs)
        repeat: false
        onTriggered: root.flushPendingUpdates()
    }

    Process {
        id: getClients
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            id: clientsCollector
            onStreamFinished: {
                let parsed;
                try {
                    parsed = JSON.parse(clientsCollector.text);
                } catch (error) {
                    console.warn("alt-tab: failed to parse hyprctl clients output", error);
                    return;
                }
                root.windowList = parsed;
                const tempWinByAddress = {};
                for (let i = 0; i < root.windowList.length; ++i) {
                    const win = root.windowList[i];
                    tempWinByAddress[win.address] = win;
                }
                root.windowByAddress = tempWinByAddress;
            }
        }
    }

    Process {
        id: getMonitors
        command: ["hyprctl", "monitors", "-j"]
        stdout: StdioCollector {
            id: monitorsCollector
            onStreamFinished: {
                try {
                    root.monitors = JSON.parse(monitorsCollector.text);
                } catch (error) {
                    console.warn("alt-tab: failed to parse hyprctl monitors output", error);
                }
            }
        }
    }
}
