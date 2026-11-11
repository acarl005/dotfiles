pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root
    property bool altTabOpen: false
    // Set by the IPC functions: cycle/cycleBack run with Alt/Super held
    property bool altTabSuperHeld: true
    // Address of the window currently highlighted by keyboard selection
    property string altTabSelectedWindowAddress: ""
}
