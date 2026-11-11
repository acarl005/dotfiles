pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "." as Common

Singleton {
    id: root

    property QtObject m3colors: QtObject {
        property color m3secondary: "#FFFFFF"
        property color m3secondaryContainer: "#333333"
        property color m3onSecondaryContainer: "#FFFFFF"
        property color m3background: "#000000"
        property color m3onBackground: "#FFFFFF"
        property color m3surfaceContainerLow: "#121212"
        property color m3surfaceContainer: "#1A1A1A"
        property color m3onSurface: "#FFFFFF"
        property color m3onSurfaceVariant: "#CCCCCC"
        property color m3outline: "#888888"
        property color m3outlineVariant: "#444444"
        property color m3shadow: "#000000"
    }

    property QtObject colors: QtObject {
        property color colSubtext: root.m3colors.m3outline
        property color colLayer0: root.m3colors.m3background
        property color colOnLayer0: root.m3colors.m3onBackground
        property color colLayer1: root.m3colors.m3surfaceContainerLow
        property color colOnLayer1: root.m3colors.m3onSurfaceVariant
        property color colLayer2: root.m3colors.m3surfaceContainer
        property color colLayer2Border: Common.ColorUtils.mix(root.m3colors.m3outlineVariant, colLayer2, 0.4)
        property color colOnLayer2: root.m3colors.m3onSurface
        property color colLayer2Hover: Common.ColorUtils.mix(colLayer2, colOnLayer2, 0.90)
        property color colSecondary: root.m3colors.m3secondary
        property color colSecondaryContainer: root.m3colors.m3secondaryContainer
        property color colOnSecondaryContainer: root.m3colors.m3onSecondaryContainer
    }

    property QtObject rounding: QtObject {
        property int windowRounding: Common.Config.options.appearance.rounding.windowRounding
    }

    property QtObject font: QtObject {
        property QtObject family: QtObject {
            property string main: Common.Config.options.appearance.font.family.main
            property string title: Common.Config.options.appearance.font.family.title
        }
        property QtObject pixelSize: QtObject {
            property int small: Common.Config.options.appearance.font.pixelSize.small
            property int normal: Common.Config.options.appearance.font.pixelSize.normal
        }
    }
}
