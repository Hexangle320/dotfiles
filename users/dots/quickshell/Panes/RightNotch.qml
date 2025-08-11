import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Assets as Assets
import qs.Data as Data

Scope {
  Variants {
    model: Quickshell.screens

    delegate: WlrLayershell {
      id: notch

      required property ShellScreen modelData

      anchors.left: true
      anchors.right: true
      anchors.top: true
      color: "transparent"
      exclusionMode: ExclusionMode.Ignore
      focusable: false
      implicitHeight: screen.height * 0.65
      layer: WlrLayer.Top
      namespace: "pain.notch.quickshell"
      screen: modelData
      surfaceFormat.opaque: false

      mask: Region {
        item: notchRect
      }

      Rectangle {
        id: notchRect

        readonly property int baseHeight: 1
        readonly property int baseWidth: 200
        readonly property int expandedHeight: 28
        readonly property int expandedWidth: 200
        readonly property int fullHeight: 600
        // readonly property int fullWidth: this.expandedWidth
        readonly property int fullWidth: 400

        anchors.right: parent.right
        bottomLeftRadius: 20
        bottomRightRadius: 0
        clip: true
        color: Assets.Colors.withAlpha(Assets.Colors.background, 0.89)
        state: Data.Globals.rightNotchState

        states: [
          State {
            name: "COLLAPSED"

            PropertyChanges {
              notchRect.height: notchRect.baseHeight
              notchRect.width: notchRect.baseWidth
            }
          },
          State {
            name: "EXPANDED"

            PropertyChanges {
              notchRect.height: notchRect.expandedHeight
              notchRect.width: notchRect.expandedWidth
            }
          },
          State {
            name: "FULLY_EXPANDED"

            PropertyChanges {
              notchRect.height: notchRect.fullHeight
              notchRect.width: notchRect.fullWidth
            }
          }
        ]
        transitions: [
          Transition {
            from: "COLLAPSED"
            reversible: true
            to: "EXPANDED"

            ParallelAnimation {
              NumberAnimation {
                duration: 150
                easing.type: Easing.InOutCubic
                property: "width"
              }

              NumberAnimation {
                duration: 180
                easing.type: Easing.Linear
                property: "height"
              }
            }
          },
          Transition {
            from: "EXPANDED"
            reversible: true
            to: "FULLY_EXPANDED"

            ParallelAnimation {
              NumberAnimation {
                duration: 150
                easing.type: Easing.InOutCubic
                property: "width"
              }

              NumberAnimation {
                duration: 100
                easing.type: Easing.Linear
                property: "height"
              }
            }
          },
          Transition {
            from: "COLLAPSED"
            reversible: true
            to: "FULLY_EXPANDED"

            ParallelAnimation {
              NumberAnimation {
                duration: 150
                easing.type: Easing.InOutCubic
                property: "width"
              }

              NumberAnimation {
                duration: 200
                easing.type: Easing.Linear
                property: "height"
              }
            }
          }
        ]

        MouseArea {
          id: rightNotchArea

          property real prevY: 0
          readonly property real sensitivity: 5
          property bool tracing: false
          property real velocity: 0

          anchors.fill: parent
          hoverEnabled: true

          onContainsMouseChanged: {
            Data.Globals.rightNotchHovered = rightNotchArea.containsMouse;
            if (Data.Globals.rightNotchState == "FULLY_EXPANDED" || Data.Globals.actWinName == "desktop") {
              return;
            }
            if (rightNotchArea.containsMouse) {
              Data.Globals.rightNotchState = "EXPANDED";
            } else {
              Data.Globals.rightNotchState = "COLLAPSED";
            }
          }
          onPositionChanged: mevent => {
            if (!tracing) {
              return;
            }
            rightNotchArea.velocity = rightNotchArea.prevY - mevent.y;
            rightNotchArea.prevY = mevent.y;

            // swipe down behaviour
            if (velocity < -rightNotchArea.sensitivity) {
              Data.Globals.rightNotchState = "FULLY_EXPANDED";
              rightNotchArea.tracing = false;
              rightNotchArea.velocity = 0;
            }

            // swipe up behaviour
            if (velocity > rightNotchArea.sensitivity) {
              Data.Globals.rightNotchState = "EXPANDED";
              rightNotchArea.tracing = false;
              rightNotchArea.velocity = 0;
            }
          }
          onPressed: mevent => {
            rightNotchArea.tracing = true;
            rightNotchArea.prevY = mevent.y;
            rightNotchArea.velocity = 0;
          }
          onReleased: mevent => {
            rightNotchArea.tracing = false;
            rightNotchArea.velocity = 0;
          }

          ColumnLayout {
            anchors.centerIn: parent
            anchors.fill: parent
            spacing: 0

            Rectangle {
              Layout.fillHeight: true
              Layout.fillWidth: true
              Layout.maximumHeight: notchRect.expandedHeight
              Layout.minimumHeight: notchRect.expandedHeight - 10
              Layout.preferredWidth: 1
              color: "transparent"
              visible: notchRect.height > notchRect.baseHeight

              RowLayout {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.top: parent.top
                layoutDirection: Qt.RightToLeft
                spacing: 8

                Text {
                  Layout.fillWidth: false
                  Layout.rightMargin: 8
                  color: Assets.Colors.primary
                  text: (Data.Globals.rightNotchState == "FULLY_EXPANDED") ? "" : ""
                  verticalAlignment: Text.AlignVCenter

                  MouseArea {
                    anchors.fill: parent

                    onClicked: mevent => {
                      if (Data.Globals.rightNotchState == "EXPANDED") {
                        Data.Globals.rightNotchState = "FULLY_EXPANDED";
                        return;
                      }

                      Data.Globals.rightNotchState = "EXPANDED";
                    }
                  }
                }
              }
            }

            Rectangle {
              Layout.fillHeight: true
              Layout.fillWidth: true
              clip: true
              color: Assets.Colors.withAlpha(Assets.Colors.surface, 0.8)
              opacity: ((notchRect.height - notchRect.expandedHeight) / (notchRect.fullHeight - notchRect.expandedHeight))
              radius: 20
              // Full Expand Card
              visible: notchRect.height > notchRect.expandedHeight

              RowLayout {
                anchors.fill: parent

                Rectangle {
                  Layout.fillHeight: true
                  Layout.fillWidth: true
                  Layout.preferredWidth: 1.6
                  color: "transparent"

                  Text {
                    anchors.centerIn: parent
                    color: Assets.Colors.primary
                    text: "Kuru Kuru Kuru Kuru"
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
