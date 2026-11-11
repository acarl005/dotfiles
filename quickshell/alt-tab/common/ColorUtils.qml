pragma Singleton
import Quickshell

Singleton {
    id: root

    function mix(color1, color2, percentage = 0.5) {
        const c1 = Qt.color(color1);
        const c2 = Qt.color(color2);
        return Qt.rgba(
            percentage * c1.r + (1 - percentage) * c2.r,
            percentage * c1.g + (1 - percentage) * c2.g,
            percentage * c1.b + (1 - percentage) * c2.b,
            percentage * c1.a + (1 - percentage) * c2.a
        );
    }

    function applyAlpha(color, alpha) {
        const c = Qt.color(color);
        const a = Math.max(0, Math.min(1, alpha));
        return Qt.rgba(c.r, c.g, c.b, a);
    }
}
