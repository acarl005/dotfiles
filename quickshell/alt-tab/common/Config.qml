pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var userOptions: ({})

    function read(path, fallback) {
        const parts = path.split(".");
        let current = userOptions;

        for (const part of parts) {
            if (current === null || current === undefined || typeof current !== "object" || !(part in current))
                return fallback;
            current = current[part];
        }

        return current === undefined || current === null ? fallback : current;
    }

    function readInt(path, fallback) {
        const parsed = Number(read(path, fallback));
        return Number.isInteger(parsed) ? parsed : fallback;
    }

    function readReal(path, fallback) {
        const parsed = Number(read(path, fallback));
        return Number.isFinite(parsed) ? parsed : fallback;
    }

    function readBool(path, fallback) {
        const value = read(path, fallback);
        return typeof value === "boolean" ? value : fallback;
    }

    function readString(path, fallback) {
        const value = read(path, fallback);
        if (typeof value !== "string")
            return fallback;
        const trimmed = value.trim();
        return trimmed.length > 0 ? trimmed : fallback;
    }

    property QtObject options: QtObject {
        property QtObject appearance: QtObject {
            property QtObject rounding: QtObject {
                property int windowRounding: root.readInt("appearance.rounding.windowRounding", 18)
            }

            property QtObject font: QtObject {
                property QtObject family: QtObject {
                    property string main: root.readString("appearance.font.family.main", "sans-serif")
                    property string title: root.readString("appearance.font.family.title", "sans-serif")
                }

                property QtObject pixelSize: QtObject {
                    property int small: root.readInt("appearance.font.pixelSize.small", 15)
                    property int normal: root.readInt("appearance.font.pixelSize.normal", 16)
                }
            }
        }

        property QtObject altTab: QtObject {
            property int columns: root.readInt("altTab.columns", 5)
            property real scale: root.readReal("altTab.scale", 0.16)
            property bool enable: root.readBool("altTab.enable", true)
            property bool closeOnFocusLoss: root.readBool("altTab.closeOnFocusLoss", true)
            property bool previewsEnabled: root.readBool("altTab.previewsEnabled", true)
            property string previewMode: root.readString("altTab.previewMode", "live")
            property bool includeInactiveMonitorPreviews: root.readBool("altTab.includeInactiveMonitorPreviews", true)
            property int previewRecaptureDelayMs: root.readInt("altTab.previewRecaptureDelayMs", 60)
            property real workspaceSpacing: root.readReal("altTab.workspaceSpacing", 5)
            property real backgroundPadding: root.readReal("altTab.backgroundPadding", 10)
            property QtObject effects: QtObject {
                property real panelOpacity: root.readReal("altTab.effects.panelOpacity", 0.92)
                property bool glassMode: root.readBool("altTab.effects.glassMode", false)
                property real glassTintStrength: root.readReal("altTab.effects.glassTintStrength", 0.35)
                property real glassBorderOpacity: root.readReal("altTab.effects.glassBorderOpacity", 0.72)
                property real glassShineOpacity: root.readReal("altTab.effects.glassShineOpacity", 0.14)
            }
        }

        property QtObject windowPreview: QtObject {
            property bool showIcons: root.readBool("windowPreview.showIcons", true)
            property real iconToWindowRatio: root.readReal("windowPreview.iconToWindowRatio", 0.25)
            property bool cropToFill: root.readBool("windowPreview.cropToFill", false)
        }

        property QtObject hacks: QtObject {
            property int arbitraryRaceConditionDelay: root.readInt("hacks.arbitraryRaceConditionDelay", 150)
            property int hyprlandEventDebounceMs: root.readInt("hacks.hyprlandEventDebounceMs", 40)
        }
    }

    FileView {
        id: configFileView
        path: Quickshell.shellPath("config.json")
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            const payload = configFileView.text().trim();
            if (!payload) {
                root.userOptions = ({});
                return;
            }

            try {
                const parsed = JSON.parse(payload);
                if (typeof parsed === "object" && parsed !== null) {
                    root.userOptions = parsed;
                } else {
                    console.warn("alt-tab: config.json must contain a JSON object; ignoring file");
                }
            } catch (error) {
                console.warn("alt-tab: failed to parse user config.json; using defaults", error);
            }
        }
    }
}
