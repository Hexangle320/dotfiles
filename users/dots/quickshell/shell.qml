import Quickshell
import QtQuick
import "Panes" as Panes

ShellRoot {
  Panes.Notch {}
  Panes.LeftNotch {}
  Panes.RightNotch {}

  // inhibit the reload popup
  Connections {
    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup();
    }
    function onReloadFailed() {
      Quickshell.inhibitReloadPopup();
    }

    target: Quickshell
  }
}
