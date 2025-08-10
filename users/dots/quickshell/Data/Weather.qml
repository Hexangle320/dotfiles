pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property var data: ""
  property string weatherJson: ""

  Process {
    id: proc

    command: ["curl", "https://wttr.in/shj?format=j1"] // replace shj with relevant airport code
    running: true

    stdout: SplitParser {
      onRead: data => {
        root.weatherJson += data;
      }
    }

    onExited: (code, stat) => {
      root.data = JSON.parse(root.weatherJson);
    }
  }

  Timer {
    interval: 1800000
    repeat: true
    running: true

    onTriggered: {
      proc.running = true;
    }
  }
}
