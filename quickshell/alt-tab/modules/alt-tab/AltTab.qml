import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "../../common"
import "../../services"
import "."

Scope {
    id: altTabScope

    readonly property var sortedWindows: HyprlandData.sortedWindowList

    function focusWindow(address) {
        const cleaned = `${address ?? ""}`.trim();
        if (!cleaned)
            return;

        const win = HyprlandData.windowByAddress[cleaned];
        if (win) {
            const targetWsName = `${win.workspace?.name ?? ""}`;
            const mon = (HyprlandData.monitors ?? []).find(m => m.id === win.monitor);
            const activeSpecialName = `${mon?.specialWorkspace?.name ?? ""}`;
            if (activeSpecialName.startsWith("special:") && activeSpecialName !== targetWsName) {
                const specialShortName = activeSpecialName.slice("special:".length);
                if (Hyprland.usingLua) {
                    Hyprland.dispatch(`hl.dsp.workspace.toggle_special('${specialShortName}')`);
                } else {
                    Hyprland.dispatch(`togglespecialworkspace ${specialShortName}`);
                }
            }
        }

        if (Hyprland.usingLua) {
            Hyprland.dispatch(`hl.dsp.focus({ window = 'address:${cleaned}' })`);
        } else {
            Hyprland.dispatch(`focuswindow address:${cleaned}`);
        }
    }

    function closeWindow(address) {
        const cleaned = `${address ?? ""}`.trim();
        if (!cleaned)
            return;

        if (Hyprland.usingLua) {
            Hyprland.dispatch(`hl.dsp.window.close({ window = 'address:${cleaned}' })`);
        } else {
            Hyprland.dispatch(`closewindow address:${cleaned}`);
        }
    }

    function commitSelection() {
        const selected = GlobalStates.altTabSelectedWindowAddress;
        GlobalStates.altTabSelectedWindowAddress = "";
        GlobalStates.altTabOpen = false;
        if (selected)
            altTabScope.focusWindow(selected);
    }

    function selectInitialWindow(direction) {
        if (HyprlandData.pendingWindowsUpdate)
            HyprlandData.flushPendingUpdates();

        const list = altTabScope.sortedWindows;
        if (!list || list.length === 0) {
            GlobalStates.altTabSelectedWindowAddress = "";
            return;
        }

        if (direction < 0) {
            GlobalStates.altTabSelectedWindowAddress = list[list.length - 1].address;
        } else {
            const initialIndex = list.length > 1 ? 1 : 0;
            GlobalStates.altTabSelectedWindowAddress = list[initialIndex].address;
        }
    }

    function stepSelection(direction) {
        const list = altTabScope.sortedWindows;
        if (!list || list.length === 0) {
            GlobalStates.altTabSelectedWindowAddress = "";
            return;
        }

        let currentIndex = list.findIndex(w => w.address === GlobalStates.altTabSelectedWindowAddress);
        if (currentIndex < 0)
            currentIndex = 0;

        const nextIndex = ((currentIndex + direction) % list.length + list.length) % list.length;
        GlobalStates.altTabSelectedWindowAddress = list[nextIndex].address;
    }

    function moveSelectionGrid(rowDelta, colDelta) {
        const list = altTabScope.sortedWindows;
        const count = list?.length ?? 0;
        if (count === 0)
            return;

        if (colDelta !== 0) {
            altTabScope.stepSelection(colDelta);
            return;
        }

        if (rowDelta !== 0) {
            const cols = Math.max(1, Math.min(Config.options.altTab.columns, count));
            let currentIndex = list.findIndex(w => w.address === GlobalStates.altTabSelectedWindowAddress);
            if (currentIndex < 0)
                currentIndex = 0;

            const totalRows = Math.ceil(count / cols);
            const currentRow = Math.floor(currentIndex / cols);
            const currentCol = currentIndex % cols;
            const targetRow = ((currentRow + rowDelta) % totalRows + totalRows) % totalRows;
            const targetIndex = Math.min(count - 1, targetRow * cols + currentCol);
            GlobalStates.altTabSelectedWindowAddress = list[targetIndex].address;
        }
    }

    function selectByNumber(position) {
        const list = altTabScope.sortedWindows;
        const index = position - 1;
        if (!list || index < 0 || index >= list.length)
            return false;

        GlobalStates.altTabSelectedWindowAddress = list[index].address;
        return true;
    }

    function cycleSelection(direction) {
        if (!GlobalStates.altTabOpen) {
            altTabScope.selectInitialWindow(direction);
            GlobalStates.altTabOpen = true;
            return;
        }
        altTabScope.stepSelection(direction);
    }

    Connections {
        target: HyprlandData
        function onSortedWindowListChanged() {
            if (!GlobalStates.altTabOpen)
                return;

            const list = altTabScope.sortedWindows;
            if (!list || list.length === 0) {
                GlobalStates.altTabSelectedWindowAddress = "";
                return;
            }

            const exists = list.some(w => w.address === GlobalStates.altTabSelectedWindowAddress);
            if (!exists) {
                const fallbackIndex = list.length > 1 ? 1 : 0;
                GlobalStates.altTabSelectedWindowAddress = list[fallbackIndex].address;
            }
        }
    }

    FloatingWindow {
        id: root
        title: "quickshell-alt-tab"
        property bool closeOnFocusLoss: Config.options.altTab.closeOnFocusLoss ?? true
        visible: GlobalStates.altTabOpen && (Config?.options.altTab.enable ?? true)
        color: "transparent"

        implicitWidth: Math.max(1, Math.round(altTabWidget.implicitWidth))
        implicitHeight: Math.max(1, Math.round(altTabWidget.implicitHeight))
        minimumSize: Qt.size(implicitWidth, implicitHeight)
        maximumSize: Qt.size(implicitWidth, implicitHeight)

        HyprlandFocusGrab {
            id: grab
            windows: [root]
            active: false
            onCleared: () => {
                if (root.closeOnFocusLoss && !active)
                    GlobalStates.altTabOpen = false;
            }
        }

        Connections {
            target: GlobalStates
            function onAltTabOpenChanged() {
                if (GlobalStates.altTabOpen) {
                    keyHandler.superHeld = GlobalStates.altTabSuperHeld;
                    keyHandler.forceActiveFocus();
                    delayedGrabTimer.start();
                } else {
                    grab.active = false;
                }
            }
        }

        Timer {
            id: delayedGrabTimer
            interval: Config.options.hacks.arbitraryRaceConditionDelay
            repeat: false
            onTriggered: {
                grab.active = GlobalStates.altTabOpen;
            }
        }

        Item {
            id: keyHandler
            anchors.fill: parent
            focus: GlobalStates.altTabOpen

            property bool superHeld: true

            function isModifierKey(key) {
                return key === Qt.Key_Alt
                    || key === Qt.Key_AltGr
                    || key === Qt.Key_Meta
                    || key === Qt.Key_Super_L
                    || key === Qt.Key_Super_R
                    || key === Qt.Key_Hyper_L
                    || key === Qt.Key_Hyper_R;
            }

            Keys.onReleased: event => {
                if (event.isAutoRepeat)
                    return;
                if (keyHandler.isModifierKey(event.key)) {
                    keyHandler.superHeld = false;
                    altTabScope.commitSelection();
                    event.accepted = true;
                }
            }

            Keys.onPressed: event => {
                if (keyHandler.isModifierKey(event.key)) {
                    keyHandler.superHeld = true;
                    event.accepted = true;
                    return;
                }

                if (event.key === Qt.Key_Escape) {
                    GlobalStates.altTabSelectedWindowAddress = "";
                    GlobalStates.altTabOpen = false;
                    event.accepted = true;
                    return;
                }

                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    altTabScope.commitSelection();
                    event.accepted = true;
                    return;
                }

                if (event.key === Qt.Key_Tab) {
                    const reverse = Boolean(event.modifiers & Qt.ShiftModifier);
                    altTabScope.stepSelection(reverse ? -1 : 1);
                    event.accepted = true;
                    return;
                }

                if (event.key === Qt.Key_Backtab) {
                    altTabScope.stepSelection(-1);
                    event.accepted = true;
                    return;
                }

                if (event.key === Qt.Key_Left || event.key === Qt.Key_H) {
                    altTabScope.moveSelectionGrid(0, -1);
                    event.accepted = true;
                    return;
                }

                if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
                    altTabScope.moveSelectionGrid(0, 1);
                    event.accepted = true;
                    return;
                }

                if (event.key === Qt.Key_Up || event.key === Qt.Key_K) {
                    altTabScope.moveSelectionGrid(-1, 0);
                    event.accepted = true;
                    return;
                }

                if (event.key === Qt.Key_Down || event.key === Qt.Key_J) {
                    altTabScope.moveSelectionGrid(1, 0);
                    event.accepted = true;
                    return;
                }

                if (event.key >= Qt.Key_1 && event.key <= Qt.Key_9) {
                    const position = event.key - Qt.Key_0;
                    if (altTabScope.selectByNumber(position) && !keyHandler.superHeld) {
                        altTabScope.commitSelection();
                    }
                    event.accepted = true;
                    return;
                }

                if (event.key === Qt.Key_0) {
                    if (altTabScope.selectByNumber(10) && !keyHandler.superHeld) {
                        altTabScope.commitSelection();
                    }
                    event.accepted = true;
                    return;
                }
            }

            AltTabWidget {
                id: altTabWidget
                anchors.fill: parent
                panelWindow: root
                visible: true
                onWindowActivated: address => {
                    GlobalStates.altTabSelectedWindowAddress = address;
                    altTabScope.commitSelection();
                }
                onWindowCloseRequested: address => {
                    altTabScope.closeWindow(address);
                }
                onCycleRequested: direction => {
                    altTabScope.stepSelection(direction);
                }
            }
        }
    }

    IpcHandler {
        target: "alt-tab"

        function toggle() {
            if (GlobalStates.altTabOpen) {
                GlobalStates.altTabSelectedWindowAddress = "";
                GlobalStates.altTabOpen = false;
            } else {
                GlobalStates.altTabSuperHeld = false;
                altTabScope.selectInitialWindow(1);
                GlobalStates.altTabOpen = true;
            }
        }
        function close() {
            GlobalStates.altTabSelectedWindowAddress = "";
            GlobalStates.altTabOpen = false;
        }
        function open() {
            GlobalStates.altTabSuperHeld = false;
            altTabScope.selectInitialWindow(1);
            GlobalStates.altTabOpen = true;
        }
        function cycle() {
            GlobalStates.altTabSuperHeld = true;
            altTabScope.cycleSelection(1);
        }
        function cycleBack() {
            GlobalStates.altTabSuperHeld = true;
            altTabScope.cycleSelection(-1);
        }
    }
}
