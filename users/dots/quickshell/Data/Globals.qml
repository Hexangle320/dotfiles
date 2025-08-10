pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Wayland

Singleton {
  id: root

  property string actWinName: activeWindow?.activated ? activeWindow?.appId : "desktop"
  readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
  property bool leftNotchHovered: false
  property string leftNotchState: "COLLAPSED"
  property bool notchHovered: false

  // one of "COLLAPSED", "EXPANDED", "FULLY_EXPANDED"
  property string notchState: "COLLAPSED"

  onActWinNameChanged: {
    if (root.actWinName == "desktop" && root.notchState == "COLLAPSED") {
      root.notchState = "EXPANDED";
    } else if (root.notchState == "EXPANDED" && !root.notchHovered) {
      root.notchState = "COLLAPSED";
    }
    if (root.actWinName == "desktop" && root.leftNotchState == "COLLAPSED") {
      root.leftNotchState = "EXPANDED";
    } else if (root.leftNotchState == "EXPANDED" && !root.leftNotchHovered) {
      root.leftNotchState = "COLLAPSED";
    }
  }
}
