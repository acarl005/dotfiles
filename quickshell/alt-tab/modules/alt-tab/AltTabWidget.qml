import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../../common"
import "../../services"
import "."

Item {
    id: root
    required property var panelWindow
    signal windowActivated(string address)
    signal windowCloseRequested(string address)
    signal cycleRequested(int direction)

    readonly property HyprlandMonitor monitor: Hyprland.focusedMonitor ?? Hyprland.monitorFor(panelWindow.screen)
    readonly property var monitorData: HyprlandData.monitors.find(m => m.id === root.monitor?.id) ?? HyprlandData.monitors[0]
    readonly property var sortedWindows: HyprlandData.sortedWindowList
    readonly property var toplevelByAddress: {
        const map = ({});
        const list = ToplevelManager.toplevels?.values ?? [];
        for (let i = 0; i < list.length; ++i) {
            const t = list[i];
            const rawAddr = t?.HyprlandToplevel?.address;
            if (rawAddr)
                map[`0x${rawAddr}`] = t;
        }
        return map;
    }

    property real scale: Config.options.altTab.scale
    readonly property real monWidth: monitor?.width ?? monitorData?.width ?? 1920
    readonly property real monHeight: monitor?.height ?? monitorData?.height ?? 1080
    readonly property real monScale: monitor?.scale ?? monitorData?.scale ?? 1.0
    property real cardWidth: Math.round((monitorData?.transform % 2 === 1) ?
        ((monHeight / monScale - (monitorData?.reserved?.[0] ?? 0) - (monitorData?.reserved?.[2] ?? 0)) * root.scale) :
        ((monWidth / monScale - (monitorData?.reserved?.[0] ?? 0) - (monitorData?.reserved?.[2] ?? 0)) * root.scale))
    property real cardHeight: Math.round((monitorData?.transform % 2 === 1) ?
        ((monWidth / monScale - (monitorData?.reserved?.[1] ?? 0) - (monitorData?.reserved?.[3] ?? 0)) * root.scale) :
        ((monHeight / monScale - (monitorData?.reserved?.[1] ?? 0) - (monitorData?.reserved?.[3] ?? 0)) * root.scale))

    property real workspaceSpacing: Config.options.altTab.workspaceSpacing
    property real panelOpacity: Math.max(0, Math.min(1, Config.options.altTab.effects.panelOpacity))
    property bool glassMode: Config.options.altTab.effects.glassMode
    property real glassTintStrength: Math.max(0, Math.min(1, Config.options.altTab.effects.glassTintStrength))
    property real glassShineOpacity: Math.max(0, Math.min(1, Config.options.altTab.effects.glassShineOpacity))
    property real effectivePanelOpacity: glassMode ? Math.min(panelOpacity, 0.72) : panelOpacity

    readonly property int maxColumns: Math.max(1, Config.options.altTab.columns)
    readonly property int effectiveColumns: Math.max(1, Math.min(maxColumns, sortedWindows.length))

    property int previewRecaptureToken: 0
    property bool previewsEnabled: Config.options.altTab.previewsEnabled
    property string previewModeRaw: Config.options.altTab.previewMode
    property string previewMode: {
        const mode = `${previewModeRaw ?? "live"}`.trim().toLowerCase();
        return (mode === "event" || mode === "snapshot") ? "event" : "live";
    }
    property bool useEventPreviewRefresh: previewsEnabled && previewMode === "event"

    implicitWidth: altTabBackground.implicitWidth
    implicitHeight: altTabBackground.implicitHeight

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (!GlobalStates.altTabOpen || !root.useEventPreviewRefresh)
                return;

            const eventName = `${event?.name ?? event?.event ?? event?.type ?? ""}`;
            if (eventName === "closewindow" || eventName === "openwindow" || eventName === "movewindow" || eventName === "movewindowv2") {
                root.previewRecaptureToken += 1;
            }
        }
    }

    Rectangle {
        id: altTabBackground
        property real padding: Config.options.altTab.backgroundPadding
        anchors.fill: parent

        implicitWidth: contentContainer.implicitWidth + padding * 2
        implicitHeight: contentContainer.implicitHeight + padding * 2
        clip: true
        color: ColorUtils.applyAlpha(
            root.glassMode
                ? ColorUtils.mix(Appearance.colors.colLayer0, Appearance.colors.colLayer1, 0.78 - root.glassTintStrength * 0.35)
                : Appearance.colors.colLayer0,
            root.effectivePanelOpacity
        )

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onPressed: mouse => mouse.accepted = true
        }

        WheelHandler {
            target: null
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: event => {
                const deltaY = event.angleDelta.y;
                if (!deltaY)
                    return;
                root.cycleRequested(deltaY > 0 ? -1 : 1);
                event.accepted = true;
            }
        }

        Rectangle {
            visible: root.glassMode
            anchors.fill: parent
            color: "transparent"
            gradient: Gradient {
                GradientStop { position: 0.0; color: ColorUtils.applyAlpha(Appearance.colors.colOnLayer0, root.glassShineOpacity * 0.35) }
                GradientStop { position: 0.42; color: ColorUtils.applyAlpha(Appearance.colors.colOnLayer0, 0.0) }
                GradientStop { position: 1.0; color: ColorUtils.applyAlpha(Appearance.m3colors.m3shadow, root.glassShineOpacity * 0.22) }
            }
        }

        Item {
            id: contentContainer
            anchors.centerIn: parent
            implicitWidth: root.sortedWindows.length > 0 ? windowGrid.implicitWidth : emptyStateBox.implicitWidth
            implicitHeight: root.sortedWindows.length > 0 ? windowGrid.implicitHeight : emptyStateBox.implicitHeight

            GridLayout {
                id: windowGrid
                visible: root.sortedWindows.length > 0
                columns: root.effectiveColumns
                rowSpacing: root.workspaceSpacing
                columnSpacing: root.workspaceSpacing

                Repeater {
                    model: ScriptModel {
                        values: root.sortedWindows
                    }
                    delegate: AltTabWindow {
                        required property var modelData
                        required property int index
                        readonly property string address: `${modelData?.address ?? ""}`
                        windowData: modelData
                        toplevel: root.toplevelByAddress[address] ?? null
                        scale: root.scale
                        cardWidth: root.cardWidth
                        cardHeight: root.cardHeight
                        widgetMonitorId: root.monitor?.id ?? -1
                        recaptureToken: root.previewRecaptureToken
                        isSelected: GlobalStates.altTabSelectedWindowAddress === address

                        Layout.preferredWidth: root.cardWidth
                        Layout.preferredHeight: root.cardHeight

                        onActivated: addr => root.windowActivated(addr)
                        onCloseRequested: addr => root.windowCloseRequested(addr)
                    }
                }
            }

            Rectangle {
                id: emptyStateBox
                visible: root.sortedWindows.length === 0
                implicitWidth: Math.max(220, root.cardWidth)
                implicitHeight: Math.max(90, Math.round(root.cardHeight * 0.6))
                radius: Math.max(8, Appearance.rounding.windowRounding * root.scale)
                color: ColorUtils.applyAlpha(Appearance.colors.colLayer1, 0.85)
                border.width: 1
                border.color: ColorUtils.applyAlpha(Appearance.colors.colLayer2Border, 0.6)

                StyledText {
                    anchors.centerIn: parent
                    text: "No open windows"
                    font.family: Appearance.font.family.title
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: Appearance.colors.colSubtext
                }
            }
        }
    }
}
