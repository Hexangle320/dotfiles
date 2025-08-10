import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.UPower

import "../Assets/" as Assets
import "../Data/" as Data
import "../Generics/" as Gen

RowLayout {
  // TOP BAR
  Rectangle {
    // Left
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    clip: true
    color: "transparent"

    RowLayout {
      anchors.bottom: parent.bottom
      // TODO animations for text change?
      anchors.left: parent.left
      anchors.top: parent.top
      spacing: 0

      Rectangle {
        Layout.leftMargin: 4
        Layout.maximumHeight: 20
        Layout.maximumWidth: 20
        Layout.minimumHeight: 20
        Layout.minimumWidth: 20
        color: Assets.Colors.primary
        // workspace number
        radius: 20

        Text {
          anchors.centerIn: parent
          color: Assets.Colors.on_primary
          font.bold: true
          font.pointSize: 10
          text: Hyprland.focusedWorkspace?.id ?? "0"
        }
      }

      Text {
        // Active Window name
        readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

        Layout.fillHeight: true
        Layout.leftMargin: 8
        color: Assets.Colors.primary
        text: Data.Globals.actWinName
        verticalAlignment: Text.AlignVCenter
      }
    }
  }

  Rectangle {
    // Time Center
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 2
    color: "transparent"

    Text {
      anchors.centerIn: parent
      color: Assets.Colors.secondary
      text: Qt.formatDateTime(Data.Clock?.date, "h:mm:ss AP")
    }
  }

  Rectangle {
    // Right
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredWidth: 1
    color: "transparent"

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
        text: (Data.Globals.notchState == "FULLY_EXPANDED") ? "" : ""
        verticalAlignment: Text.AlignVCenter

        MouseArea {
          anchors.fill: parent

          onClicked: mevent => {
            if (Data.Globals.notchState == "EXPANDED") {
              Data.Globals.notchState = "FULLY_EXPANDED";
              return;
            }

            Data.Globals.notchState = "EXPANDED";
          }
        }
      }

      Rectangle {
        Layout.maximumHeight: 20
        Layout.minimumHeight: 20
        Layout.minimumWidth: batText.width + 20
        color: Assets.Colors.primary
        radius: 20

        Behavior on Layout.minimumWidth {
          NumberAnimation {
            duration: 150
            easing.type: Easing.Linear
          }
        }

        Text { // Battery Text
          id: batText

          readonly property real batCharging: UPower.displayDevice.state == UPowerDeviceState.Charging
          readonly property string batIcon: {
            (batPercentage > 0.98) ? batIcons[0] : (batPercentage > 0.90) ? batIcons[1] : (batPercentage > 0.80) ? batIcons[2] : (batPercentage > 0.70) ? batIcons[3] : (batPercentage > 0.60) ? batIcons[4] : (batPercentage > 0.50) ? batIcons[5] : (batPercentage > 0.40) ? batIcons[6] : (batPercentage > 0.30) ? batIcons[7] : (batPercentage > 0.20) ? batIcons[8] : (batPercentage > 0.10) ? batIcons[9] : batIcons[10];
          }
          readonly property list<string> batIcons: ["󰁹", "󰂂", "󰂁", "󰂀", "󰁿", "󰁾", "󰁽", "󰁼", "󰁻", "󰁺", "󰂃"]
          readonly property real batPercentage: UPower.displayDevice.percentage
          readonly property string chargeIcon: batIcons[10 - chargeIconIndex]
          property int chargeIconIndex: 0

          anchors.centerIn: parent
          color: Assets.Colors.on_primary
          font.pointSize: 11
          text: Math.round(batPercentage * 100) + "% " + ((batCharging) ? chargeIcon : batIcon)
        }

        Timer {
          interval: 600
          repeat: true
          running: batText.batCharging

          onTriggered: () => {
            batText.chargeIconIndex = batText.chargeIconIndex % 10;
            batText.chargeIconIndex += 1;
          }
        }
      }

      Rectangle {
        Layout.maximumHeight: 20
        Layout.minimumHeight: 20
        Layout.minimumWidth: soundText.width + 20
        color: Assets.Colors.secondary
        radius: 20

        Behavior on Layout.minimumWidth {
          NumberAnimation {
            duration: 150
            easing.type: Easing.Linear
          }
        }

        Text {
          id: soundText

          anchors.centerIn: parent
          color: Assets.Colors.on_secondary
          font.pointSize: 11
          text: Math.round(Data.Audio.volume * 100) + "%" + " " + Data.Audio.volIcon

          MouseArea {
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
            anchors.fill: parent

            onClicked: mouse => {
              switch (mouse.button) {
              case Qt.MiddleButton:
                Data.Audio.sink.audio.muted = !Data.Audio.muted;
                break;
              case Qt.RightButton:
                Data.Audio.source.audio.muted = !Data.Audio.source.audio.muted;
                break;
              }
            }
            onWheel: event => Data.Audio.wheelAction(event)
          }
        }
      }
    }
  }
}
