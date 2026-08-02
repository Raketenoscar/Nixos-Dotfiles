import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "config.js" as Config

PanelWindow {
    id: root

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 55
    color: "transparent"
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        height: 45
        radius: 10
        color: Config.colors.bg
        border {
            color: Config.colors.purple
            width: 2
        }
    }
    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 10
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 12
        Repeater {
            model: 9
            Text {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                Layout.alignment: Qt.AlignVCenter
                text: index + 1
                color: isActive ? Config.colors.cyan : (ws ? Config.colors.blue : Config.colors.gray)
                font {
                    pixelSize: Config.bar.fontSize
                    bold: true
                }
            }
        }
        Item {
            Layout.fillWidth: true
        }
        // Clock
        Text { 
            id: clock
            color: Config.colors.blue
            font { pixelSize: Config.bar.fontSize; bold: true } 
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(new Date(), "HH:mm")
            Timer { 
                interval: 1000
                running: true
                repeat: true
                onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm") 
            } 
        }
        // Bluetooth
        Text {
            Layout.alignment: Qt.AlignVCenter
            color: Config.colors.blue
            font {
                pixelSize: Config.bar.fontSize
                bold: true
            }
            text: ""
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: bluetoothlaunch.running = true
            }
        }

        Process {
            id: bluetoothlaunch
            command: ["alacritty", "-e", "bluetui"]
        }
        // WiFi
        Item {
            id: wifiWidget
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: wifiIcon.implicitWidth
            implicitHeight: wifiIcon.implicitHeight

            property bool isConnected: false
            property int signalPercent: 0

            property string icon: {
                if (!isConnected) return "󰤭"
                if (signalPercent >= 75) return "󰤨"
                if (signalPercent >= 50) return "󰤥"
                if (signalPercent >= 25) return "󰤢"
                if (signalPercent >= 10) return "󰤟"
                return "󰤯"
            }

            Text {
                id: wifiIcon
                anchors.centerIn: parent
                text: wifiWidget.icon
                color: wifiWidget.isConnected ? Config.colors.cyan : Config.colors.gray
                font {
                    pixelSize: Config.bar.fontSize
                    bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: wifiLaunch.running = true
                }
            }

            Process {
                id: wifiLaunch
                command: ["alacritty", "-e", "impala"]
            }

            Process {
                id: wifiPoll
                command: [
                    "bash", "-c",
                    "iwctl station wlan0 show 2>/dev/null | awk '/State/ && !/Settable/ { for(i=1;i<=NF;i++) if($i ~ /^[a-z]/) { state=$i; break } } /RSSI/ && !/Average/ { for(i=1;i<=NF;i++) if($i ~ /^-?[0-9]+$/) { rssi=$i; break } } END { print state; print rssi }'"
                ]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: {
                        let lines = text.trim().split("\n")
                        if (lines.length >= 2) {
                            wifiWidget.isConnected = lines[0] === "connected"
                            let rssi = parseInt(lines[1])
                            if (!isNaN(rssi)) {
                                wifiWidget.signalPercent = Math.min(100, Math.max(0, 2 * (rssi + 100)))
                            }
                        } else {
                            wifiWidget.isConnected = false
                        }
                    }
                }
            }

            Timer {
                interval: 3000
                running: true
                repeat: true
                onTriggered: {
                    wifiPoll.running = false
                    wifiPoll.running = true
                }
            }
        }
        // Audio
        Text {
            Layout.alignment: Qt.AlignVCenter
            color: Config.colors.blue
            font {
                pixelSize: Config.bar.fontSize
                bold: true
            }
            text: "󰕾"
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: audioLaunch.running = true
            }
        }

        Process {
            id: audioLaunch
            command: ["alacritty", "-e", "wiremix"]
        }
        // CPU
        Text {
            Layout.alignment: Qt.AlignVCenter
            color: Config.colors.blue
            font {
                pixelSize: Config.bar.fontSize
                bold: true
            }
            text: "󰍛"
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: cpuLaunch.running = true
            }
        }

        Process {
            id: cpuLaunch
            command: ["alacritty", "-e", "btop"]
        }
        // Battery
        Text {
            id: battery
            Layout.alignment: Qt.AlignVCenter
            color: Config.colors.blue
            font {
                pixelSize: Config.bar.fontSize
                bold: true
            }
            property int percentage: 100
            property string status: "Unknown"
            property string icon: {
                if (status === "Charging")
                    return "󰂄"
                if (percentage >= 90)
                    return "󰁹"
                else if (percentage >= 70)
                    return "󰂀"
                else if (percentage >= 50)
                    return "󰁿"
                else if (percentage >= 30)
                    return "󰁾"
                else if (percentage >= 15)
                    return "󰁼"
                else
                    return "󰁺"
            }
            text: icon 
            Process {
                id: batteryProcess
                command: [
                    "bash",
                    "-c",
                    "cat /sys/class/power_supply/BAT0/capacity && cat /sys/class/power_supply/BAT0/status"
                ]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: {
                        let lines = text.trim().split("\n")

                        if (lines.length >= 2) {
                            battery.percentage = parseInt(lines[0])
                            battery.status = lines[1]
                        }
                    }
                }
            }
            Timer {
                interval: 1000
                running: true
                repeat: true

                onTriggered: {
                    batteryProcess.running = false
                    batteryProcess.running = true
                }
            }
        }
    }
}
