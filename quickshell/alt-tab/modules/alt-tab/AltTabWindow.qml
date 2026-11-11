import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import "../../common"
import "../../services"

Item {
    id: root
    required property var windowData
    property var toplevel: null
    property real scale: Config.options.altTab.scale
    property real cardWidth: 300
    property real cardHeight: 180
    property int widgetMonitorId: 0
    property int recaptureToken: 0
    property bool isSelected: false
    property bool hovered: false

    signal activated(string address)
    signal closeRequested(string address)

    property bool showIcons: Config.options.windowPreview.showIcons
    property real iconToWindowRatio: Config.options.windowPreview.iconToWindowRatio
    property bool cropToFill: Config.options.windowPreview.cropToFill
    property bool previewsEnabled: Config.options.altTab.previewsEnabled
    property bool includeInactiveMonitorPreviews: Config.options.altTab.includeInactiveMonitorPreviews
    property int previewRecaptureDelayMs: Config.options.altTab.previewRecaptureDelayMs
    property bool glassMode: Config.options.altTab.effects.glassMode
    property real glassTintStrength: Math.max(0, Math.min(1, Config.options.altTab.effects.glassTintStrength))
    property real glassBorderOpacity: Math.max(0, Math.min(1, Config.options.altTab.effects.glassBorderOpacity))
    property string previewModeRaw: Config.options.altTab.previewMode
    property string previewMode: {
        const mode = `${previewModeRaw ?? "live"}`.trim().toLowerCase();
        return (mode === "event" || mode === "snapshot") ? "event" : "live";
    }
    property bool livePreviewEnabled: previewsEnabled && previewMode === "live"
    property bool previewCaptureEnabled: true
    property bool shouldCapturePreview: {
        if (!GlobalStates.altTabOpen || !previewsEnabled || !previewCaptureEnabled || !root.toplevel)
            return false;
        if (includeInactiveMonitorPreviews)
            return true;
        return (windowData?.monitor ?? -1) === widgetMonitorId;
    }

    property var entry: {
        DesktopEntries.applications.values;
        return DesktopEntries.heuristicLookup(windowData?.class);
    }
    property string iconName: {
        const raw = `${entry?.icon ?? ""}`.trim();
        const withoutProviderPrefix = raw.replace(/^image:\/\/icon\//, "");
        const withoutQuery = withoutProviderPrefix.split("?")[0].trim();
        return withoutQuery.length > 0 ? withoutQuery : "";
    }
    property var iconPath: iconName.length > 0 ? Quickshell.iconPath(iconName, "image-missing") : ""

    readonly property real cardRadius: Math.max(8, Appearance.rounding.windowRounding * root.scale)
    readonly property real cardPadding: Math.max(6, Math.round(48 * root.scale))
    readonly property real headerHeight: Math.max(22, Math.round(150 * root.scale))

    implicitWidth: cardWidth
    implicitHeight: cardHeight
    width: cardWidth
    height: cardHeight

    Rectangle {
        id: cardBackground
        anchors.fill: parent
        radius: root.cardRadius
        color: {
            const base = root.isSelected
                ? ColorUtils.mix(Appearance.colors.colLayer2, Appearance.colors.colSecondaryContainer, 0.45)
                : (root.hovered ? Appearance.colors.colLayer2Hover : Appearance.colors.colLayer1);
            if (root.glassMode)
                return ColorUtils.applyAlpha(ColorUtils.mix(base, Appearance.colors.colLayer0, 0.38 - root.glassTintStrength * 0.25), 0.78);
            return ColorUtils.applyAlpha(base, root.isSelected ? 0.98 : 0.90);
        }
        border.width: 1
        border.color: root.isSelected
            ? Appearance.colors.colSecondary
            : (root.hovered
                ? Appearance.colors.colLayer2Hover
                : ColorUtils.applyAlpha(Appearance.colors.colLayer2Border, root.glassMode ? root.glassBorderOpacity : 0.7))

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.cardPadding
            spacing: Math.max(4, Math.round(root.cardPadding * 0.6))

            StyledText {
                Layout.fillWidth: true
                Layout.preferredHeight: root.headerHeight
                Layout.alignment: Qt.AlignVCenter
                text: (root.windowData?.title && `${root.windowData.title}`.trim().length > 0)
                    ? root.windowData.title
                    : (root.windowData?.class ?? "Window")
                elide: Text.ElideRight
                maximumLineCount: 1
                font.family: Appearance.font.family.title
                font.pixelSize: Math.max(11, Math.round(root.headerHeight * 0.56))
                font.weight: root.isSelected ? Font.DemiBold : Font.Medium
                color: root.isSelected ? Appearance.colors.colOnSecondaryContainer : Appearance.colors.colOnLayer1
            }

            Item {
                id: previewContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                readonly property real previewRadius: Math.max(6, root.cardRadius - root.cardPadding * 0.5)

                ScreencopyView {
                    id: windowPreview
                    readonly property real srcAspect: {
                        const w = root.windowData?.size?.[0] ?? 0;
                        const h = root.windowData?.size?.[1] ?? 0;
                        return (w > 0 && h > 0) ? (w / h) : 1;
                    }
                    anchors.centerIn: parent
                    width: root.cropToFill
                        ? Math.max(parent.width, parent.height * srcAspect)
                        : Math.min(parent.width, parent.height * srcAspect)
                    height: root.cropToFill
                        ? Math.max(parent.height, parent.width / srcAspect)
                        : Math.min(parent.height, parent.width / srcAspect)
                    captureSource: root.shouldCapturePreview ? root.toplevel : null
                    live: root.livePreviewEnabled
                    layer.enabled: true
                    layer.smooth: true
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: previewMask
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1.0
                    }
                }

                Item {
                    id: previewMask
                    width: windowPreview.width
                    height: windowPreview.height
                    anchors.centerIn: parent
                    visible: false
                    layer.enabled: true
                    layer.smooth: true
                    Rectangle {
                        anchors.fill: parent
                        radius: previewContainer.previewRadius
                    }
                }

                Image {
                    id: centerWindowIcon
                    anchors.centerIn: parent
                    visible: root.showIcons && root.iconPath !== ""
                    readonly property real iconSize: Math.max(20, Math.min(previewContainer.width, previewContainer.height) * root.iconToWindowRatio)
                    width: iconSize
                    height: iconSize
                    source: root.iconPath
                    sourceSize: Qt.size(Math.round(iconSize), Math.round(iconSize))
                    opacity: root.shouldCapturePreview ? 0.85 : 1.0
                }
            }
        }
    }

    MouseArea {
        id: cardMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: event => {
            const addr = `${root.windowData?.address ?? ""}`.trim();
            if (!addr)
                return;
            if (event.button === Qt.LeftButton) {
                root.activated(addr);
                event.accepted = true;
            } else if (event.button === Qt.MiddleButton) {
                root.closeRequested(addr);
                event.accepted = true;
            }
        }
    }

    function refreshCapture() {
        if (!GlobalStates.altTabOpen || livePreviewEnabled || !previewsEnabled)
            return;

        root.previewCaptureEnabled = false;
        previewResetTimer.restart();
    }

    Timer {
        id: previewResetTimer
        interval: Math.max(1, root.previewRecaptureDelayMs)
        repeat: false
        onTriggered: root.previewCaptureEnabled = true
    }

    onRecaptureTokenChanged: {
        if (recaptureToken > 0)
            root.refreshCapture();
    }
}
