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
  property bool rightNotchHovered: false
  property string rightNotchState: "COLLAPSED"

  onActWinNameChanged: {
    if (root.actWinName == "desktop" && root.leftNotchState == "COLLAPSED") {
      root.leftNotchState = "EXPANDED";
    } else if (root.leftNotchState == "EXPANDED" && !root.leftNotchHovered) {
      root.leftNotchState = "COLLAPSED";
    }
    if (root.actWinName == "desktop" && root.rightNotchState == "COLLAPSED") {
      root.rightNotchState = "EXPANDED";
    } else if (root.rightNotchState == "EXPANDED" && !root.rightNotchHovered) {
      root.rightNotchState = "COLLAPSED";
    }
  }
}
