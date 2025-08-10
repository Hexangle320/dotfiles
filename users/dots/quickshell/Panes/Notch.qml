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
        readonly property int expandedWidth: 600
        readonly property int fullHeight: 180
        readonly property int fullWidth: this.expandedWidth

        anchors.horizontalCenter: parent.horizontalCenter
        bottomLeftRadius: 20
        bottomRightRadius: 20
        clip: true
        color: Assets.Colors.withAlpha(Assets.Colors.background, 0.89)
        state: Data.Globals.notchState

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
          id: notchArea

          property real prevY: 0
          readonly property real sensitivity: 5
          property bool tracing: false
          property real velocity: 0

          anchors.fill: parent
          hoverEnabled: true

          onContainsMouseChanged: {
            Data.Globals.notchHovered = notchArea.containsMouse;
            if (Data.Globals.notchState == "FULLY_EXPANDED" || Data.Globals.actWinName == "desktop") {
              return;
            }
            if (notchArea.containsMouse) {
              Data.Globals.notchState = "EXPANDED";
            } else {
              Data.Globals.notchState = "COLLAPSED";
            }
          }
          onPositionChanged: mevent => {
            if (!tracing) {
              return;
            }
            notchArea.velocity = notchArea.prevY - mevent.y;
            notchArea.prevY = mevent.y;

            // swipe down behaviour
            if (velocity < -notchArea.sensitivity) {
              Data.Globals.notchState = "FULLY_EXPANDED";
              notchArea.tracing = false;
              notchArea.velocity = 0;
            }

            // swipe up behaviour
            if (velocity > notchArea.sensitivity) {
              Data.Globals.notchState = "EXPANDED";
              notchArea.tracing = false;
              notchArea.velocity = 0;
            }
          }
          onPressed: mevent => {
            notchArea.tracing = true;
            notchArea.prevY = mevent.y;
            notchArea.velocity = 0;
          }
          onReleased: mevent => {
            notchArea.tracing = false;
            notchArea.velocity = 0;
          }

          ColumnLayout {
            anchors.centerIn: parent
            anchors.fill: parent
            spacing: 0

            TopBar {
              Layout.fillWidth: true
              Layout.maximumHeight: notchRect.expandedHeight
              Layout.minimumHeight: notchRect.expandedHeight - 10
              opacity: (notchRect.width - notchRect.baseWidth) / (notchRect.expandedWidth - notchRect.baseWidth)
              visible: notchRect.height > notchRect.baseHeight
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

                AnimatedImage {
                  Layout.fillHeight: true
                  Layout.fillWidth: true
                  Layout.preferredWidth: 1
                  fillMode: Image.PreserveAspectCrop
                  horizontalAlignment: Image.AlignRight
                  playing: parent.visible
                  source: "https://duiqt.github.io/herta_kuru/static/img/hertaa1.gif"
                }

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
