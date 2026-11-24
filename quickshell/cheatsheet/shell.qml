//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QPA_PLATFORMTHEME=

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

ShellRoot {
    id: root

    property bool isOpen: false
    property string searchQuery: ""
    property var categories: []

    readonly property string cheatsheetPath: {
        const runtimeDir = Quickshell.env("XDG_RUNTIME_DIR");
        return (runtimeDir && runtimeDir.length > 0 ? runtimeDir : "/tmp") + "/hypr-cheatsheet.json";
    }

    // Cyberdream palette (matching wofi/style.css and hyprland.lua)
    readonly property color colBg: "#99000000"
    readonly property color colCard: "#660a0a0a"
    readonly property color colCardBorder: "#38ffffff"
    readonly property color colPanelBorder: "#78bd5eff"
    readonly property color colMagenta: "#bd5eff"
    readonly property color colLavender: "#d08fff"
    readonly property color colRed: "#ff6e5e"
    readonly property color colBrightRed: "#ff9a8f"
    readonly property color colText: "#ffe8e5"
    readonly property color colSubtext: "#a89fb5"
    readonly property color colKeyBg: "#1a1a1a"
    readonly property color colKeyBorder: "#45ffffff"
    readonly property color colModBg: "#33bd5eff"
    readonly property color colModBorder: "#77d08fff"
    readonly property color colModText: "#ecd4ff"
    readonly property string fontFamily: "Inconsolata Nerd Font"

    // Dual-layer neon text glow matching CSS:
    // text-shadow: 0px 0px 4px @red, 0px 0px 8px @brightRed;
    component GlowText: Item {
        id: glowText
        property alias text: fg.text
        property alias color: fg.color
        property alias font: fg.font
        property color glowColor: root.colRed
        property color outerGlowColor: root.colBrightRed

        implicitWidth: fg.implicitWidth
        implicitHeight: fg.implicitHeight

        Text {
            anchors.centerIn: parent
            text: fg.text
            font: fg.font
            color: glowText.outerGlowColor
            style: Text.Outline
            styleColor: glowText.outerGlowColor
            opacity: 0.45

            layer.enabled: true
            layer.smooth: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 0.95
                blurMax: 42
                blurMultiplier: 0.4
                autoPaddingEnabled: true
            }
        }

        Text {
            anchors.centerIn: parent
            text: fg.text
            font: fg.font
            color: glowText.glowColor
            style: Text.Outline
            styleColor: glowText.glowColor
            opacity: 0.6

            layer.enabled: true
            layer.smooth: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 0.75
                blurMax: 22
                autoPaddingEnabled: true
            }
        }

        Text {
            id: fg
            anchors.centerIn: parent
            color: "#ffffff"
        }
    }

    function open() {
        cheatsheetFile.reload();
        root.searchQuery = "";
        root.isOpen = true;
    }

    function close() {
        root.isOpen = false;
        root.searchQuery = "";
    }

    function toggle() {
        if (root.isOpen)
            root.close();
        else
            root.open();
    }

    function categoryIcon(name) {
        switch (name) {
        case "Applications":
            return "󰀻";
        case "Windows":
            return "";
        case "Workspaces & Monitors":
            return "󰍹";
        case "Screenshots & Recording":
            return "󰄀";
        case "System & UI":
            return "";
        default:
            return "";
        }
    }

    function formatKey(raw) {
        const key = raw.trim();
        switch (key.toLowerCase()) {
        case "super":
            return "Super";
        case "shift":
            return "Shift";
        case "ctrl":
            return "Ctrl";
        case "alt":
            return "Alt";
        case "slash":
            return "/";
        case "return":
            return "Enter";
        case "mouse:272":
            return "LMB";
        case "mouse:273":
            return "RMB";
        case "mouse_down":
            return "Scroll ↓";
        case "mouse_up":
            return "Scroll ↑";
        case "arrows":
            return "←↑↓→";
        case "up/down":
            return "↑/↓";
        default:
            return key;
        }
    }

    function isModifier(raw) {
        const lower = raw.trim().toLowerCase();
        return lower === "super" || lower === "shift" || lower === "ctrl" || lower === "alt";
    }

    function tokenizeKeys(keysStr) {
        const tokens = [];
        const str = `${keysStr ?? ""}`;
        // Split on " + " or " / " or standalone "+" while preserving separators
        const regex = /(\s*\+\s*|\s+\/\s+)/g;
        let lastIndex = 0;
        let match;

        while ((match = regex.exec(str)) !== null) {
            if (match.index > lastIndex) {
                const part = str.slice(lastIndex, match.index).trim();
                if (part.length > 0) {
                    tokens.push({
                        text: root.formatKey(part),
                        isSep: false,
                        isMod: root.isModifier(part)
                    });
                }
            }
            const sep = match[0].trim();
            tokens.push({
                text: sep,
                isSep: true,
                isMod: false
            });
            lastIndex = regex.lastIndex;
        }

        if (lastIndex < str.length) {
            const tail = str.slice(lastIndex).trim();
            if (tail.length > 0) {
                tokens.push({
                    text: root.formatKey(tail),
                    isSep: false,
                    isMod: root.isModifier(tail)
                });
            }
        }

        return tokens;
    }

    readonly property var filteredCategories: {
        const q = root.searchQuery.trim().toLowerCase();
        if (!q)
            return root.categories;

        const out = [];
        for (let i = 0; i < root.categories.length; ++i) {
            const cat = root.categories[i];
            const catMatch = `${cat.category ?? ""}`.toLowerCase().includes(q);
            const binds = cat.binds ?? [];
            const matched = [];

            for (let j = 0; j < binds.length; ++j) {
                const b = binds[j];
                if (catMatch
                        || `${b.keys ?? ""}`.toLowerCase().includes(q)
                        || `${b.desc ?? ""}`.toLowerCase().includes(q)) {
                    matched.push(b);
                }
            }

            if (matched.length > 0) {
                out.push({
                    category: cat.category,
                    binds: matched
                });
            }
        }
        return out;
    }

    Connections {
        target: Quickshell

        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }
    }

    FileView {
        id: cheatsheetFile
        path: root.cheatsheetPath
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            const payload = cheatsheetFile.text().trim();
            if (!payload) {
                root.categories = [];
                return;
            }
            try {
                const parsed = JSON.parse(payload);
                if (Array.isArray(parsed)) {
                    root.categories = parsed;
                }
            } catch (e) {
                console.warn("cheatsheet: failed to parse", root.cheatsheetPath, e);
            }
        }
    }

    IpcHandler {
        target: "cheatsheet"

        function toggle() {
            root.toggle();
        }

        function open() {
            root.open();
        }

        function close() {
            root.close();
        }
    }

    LazyLoader {
        id: overlayLoader
        active: root.isOpen

        FloatingWindow {
            id: overlay
            title: "quickshell-cheatsheet"
            visible: true
            color: "transparent"

            readonly property var mon: Hyprland.focusedMonitor
            readonly property real monScale: (mon && mon.scale > 0) ? mon.scale : 1.0
            readonly property real monWidth: (mon ? mon.width : 1920) / monScale
            readonly property real monHeight: (mon ? mon.height : 1080) / monScale
            readonly property int targetWidth: Math.round(Math.min(1320, monWidth * 0.85))
            readonly property int maxPanelHeight: Math.round(monHeight * 0.84)

            implicitWidth: targetWidth
            implicitHeight: Math.max(200, Math.round(Math.min(maxPanelHeight, mainLayout.implicitHeight + 36)))
            minimumSize: Qt.size(implicitWidth, implicitHeight)
            maximumSize: Qt.size(implicitWidth, implicitHeight)

            HyprlandFocusGrab {
                id: grab
                windows: [overlay]
                active: false
                onCleared: () => {
                    if (!active)
                        root.close();
                }
            }

            Timer {
                id: delayedGrabTimer
                interval: 150
                repeat: false
                onTriggered: {
                    grab.active = root.isOpen;
                }
            }

            Component.onCompleted: {
                searchInput.forceActiveFocus();
                delayedGrabTimer.start();
            }

        // Cheatsheet panel (Hyprland provides native border, rounding, and blur)
        Rectangle {
            id: panel
            anchors.fill: parent

            readonly property real maxPanelWidth: overlay.targetWidth
            readonly property real maxPanelHeight: overlay.maxPanelHeight
            readonly property int colCount: {
                const count = root.filteredCategories.length;
                if (count <= 1)
                    return 1;
                if (maxPanelWidth >= 1080 && count >= 3)
                    return 3;
                if (maxPanelWidth >= 680)
                    return 2;
                return 1;
            }

            readonly property var columnsData: {
                const n = colCount;
                const cols = [];
                const heights = [];
                for (let i = 0; i < n; ++i) {
                    cols.push([]);
                    heights.push(0);
                }

                const cats = root.filteredCategories;
                for (let i = 0; i < cats.length; ++i) {
                    let bestCol = 0;
                    for (let c = 1; c < n; ++c) {
                        if (heights[c] < heights[bestCol])
                            bestCol = c;
                    }
                    cols[bestCol].push(cats[i]);
                    heights[bestCol] += (cats[i].binds?.length ?? 0) + 2;
                }
                return cols;
            }

            color: root.colBg

            ColumnLayout {
                id: mainLayout
                anchors.fill: parent
                anchors.margins: 18
                spacing: 14

                // Header bar
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14

                    GlowText {
                        text: "  Hyprland Keybindings"
                        color: "#ffffff"
                        font.family: root.fontFamily
                        font.pixelSize: 20
                        font.bold: true
                    }

                    // Search box (matching GTK/wofi lavender inset shadow)
                    Rectangle {
                        id: searchBox
                        Layout.fillWidth: true
                        Layout.maximumWidth: 380
                        Layout.preferredHeight: 34
                        radius: 8
                        color: "#4d282828"

                        Item {
                            id: searchMask
                            anchors.fill: parent
                            visible: false
                            layer.enabled: true

                            Rectangle {
                                anchors.fill: parent
                                radius: searchBox.radius
                                color: "#ffffff"
                            }
                        }

                        // Inset lavender glow clipped to rounded corners
                        Item {
                            anchors.fill: parent
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                maskEnabled: true
                                maskSource: searchMask
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: -5
                                radius: searchBox.radius + 4
                                color: "transparent"
                                border.width: 8
                                border.color: "#40d08fff"

                                layer.enabled: true
                                layer.smooth: true
                                layer.effect: MultiEffect {
                                    blurEnabled: true
                                    blur: 0.65
                                    blurMax: 16
                                }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 8

                            Text {
                                text: ""
                                color: "#888888"
                                font.family: root.fontFamily
                                font.pixelSize: 13
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "Filter keybindings..."
                                    color: root.colSubtext
                                    font.family: root.fontFamily
                                    font.pixelSize: 14
                                    visible: searchInput.text.length === 0
                                }

                                TextInput {
                                    id: searchInput
                                    anchors.fill: parent
                                    verticalAlignment: TextInput.AlignVCenter
                                    color: root.colText
                                    selectionColor: root.colMagenta
                                    selectedTextColor: "#ffffff"
                                    font.family: root.fontFamily
                                    font.pixelSize: 14
                                    text: root.searchQuery
                                    onTextEdited: root.searchQuery = text

                                    Keys.onEscapePressed: root.close()
                                    Keys.onPressed: event => {
                                        if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_U) {
                                            root.searchQuery = "";
                                            event.accepted = true;
                                        }
                                    }
                                }
                            }

                            Text {
                                text: "󰅖"
                                color: root.colSubtext
                                font.family: root.fontFamily
                                font.pixelSize: 13
                                visible: root.searchQuery.length > 0

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.searchQuery = "";
                                        searchInput.forceActiveFocus();
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "Esc or Super + / to close"
                        color: root.colSubtext
                        font.family: root.fontFamily
                        font.pixelSize: 13
                    }
                }

                // Subtle accent divider
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: root.colMagenta }
                        GradientStop { position: 0.5; color: root.colRed }
                        GradientStop { position: 1.0; color: "#22ff6e5e" }
                    }
                }

                // Empty state
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    visible: root.filteredCategories.length === 0

                    Text {
                        anchors.centerIn: parent
                        text: root.categories.length === 0
                              ? "No keybindings loaded (" + root.cheatsheetPath + ")"
                              : "No matching keybindings"
                        color: root.colSubtext
                        font.family: root.fontFamily
                        font.pixelSize: 15
                    }
                }

                // Scrollable multi-column category grid
                Flickable {
                    id: scrollArea
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: columnsRow.implicitHeight
                    visible: root.filteredCategories.length > 0
                    clip: true
                    contentWidth: width
                    contentHeight: columnsRow.implicitHeight
                    boundsBehavior: Flickable.StopAtBounds

                    RowLayout {
                        id: columnsRow
                        width: scrollArea.width
                        spacing: 14

                        Repeater {
                            model: panel.columnsData

                            ColumnLayout {
                                id: colLayout
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.preferredWidth: 1
                                Layout.alignment: Qt.AlignTop
                                spacing: 14

                                Repeater {
                                    model: colLayout.modelData

                                    // Category card
                                    Rectangle {
                                        id: catCard
                                        required property var modelData
                                        Layout.fillWidth: true
                                        implicitHeight: catContent.implicitHeight + 22
                                        radius: 8
                                        color: root.colCard
                                        border.width: 1
                                        border.color: root.colCardBorder

                                        ColumnLayout {
                                            id: catContent
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            anchors.margins: 12
                                            spacing: 8

                                            // Category title
                                            RowLayout {
                                                Layout.fillWidth: true
                                                spacing: 8

                                                GlowText {
                                                    text: root.categoryIcon(catCard.modelData.category)
                                                    color: "#ffffff"
                                                    font.family: root.fontFamily
                                                    font.pixelSize: 15
                                                }

                                                GlowText {
                                                    text: catCard.modelData.category
                                                    color: "#ffffff"
                                                    font.family: root.fontFamily
                                                    font.pixelSize: 15
                                                    font.bold: true
                                                }

                                                Rectangle {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 1
                                                    color: "#28ffffff"
                                                }
                                            }

                                            // Bindings in category
                                            Repeater {
                                                model: catCard.modelData.binds

                                                RowLayout {
                                                    id: bindRow
                                                    required property var modelData
                                                    Layout.fillWidth: true
                                                    spacing: 10

                                                    // Keycap pills
                                                    Row {
                                                        Layout.alignment: Qt.AlignVCenter
                                                        spacing: 4

                                                        Repeater {
                                                            model: root.tokenizeKeys(bindRow.modelData.keys)

                                                            Rectangle {
                                                                id: keyPill
                                                                required property var modelData
                                                                height: 22
                                                                implicitWidth: modelData.isSep
                                                                               ? keyLabel.implicitWidth + 2
                                                                               : keyLabel.implicitWidth + 10
                                                                radius: 4
                                                                color: modelData.isSep
                                                                       ? "transparent"
                                                                       : (modelData.isMod ? root.colModBg : root.colKeyBg)
                                                                border.width: modelData.isSep ? 0 : 1
                                                                border.color: modelData.isMod ? root.colModBorder : root.colKeyBorder

                                                                Text {
                                                                    id: keyLabel
                                                                    anchors.centerIn: parent
                                                                    text: keyPill.modelData.text
                                                                    color: keyPill.modelData.isSep
                                                                           ? root.colSubtext
                                                                           : (keyPill.modelData.isMod ? root.colModText : root.colText)
                                                                    font.family: root.fontFamily
                                                                    font.pixelSize: 12
                                                                    font.bold: keyPill.modelData.isMod
                                                                }
                                                            }
                                                        }
                                                    }

                                                    // Description
                                                    Text {
                                                        Layout.fillWidth: true
                                                        Layout.alignment: Qt.AlignVCenter
                                                        horizontalAlignment: Text.AlignRight
                                                        text: bindRow.modelData.desc
                                                        color: root.colText
                                                        font.family: root.fontFamily
                                                        font.pixelSize: 13
                                                        wrapMode: Text.WordWrap
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    }
}
