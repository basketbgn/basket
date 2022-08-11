import QtQuick 2.0
import QtQuick.Controls 2.0
Item {
    signal isChecked(bool check)
    property alias check: control.checked
    Switch {
        id: control
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        checked: true
        indicator: Rectangle {
            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            radius: 20
            color: control.checked ? "#17a81a" : "#FF95A4"
            border.color: indicatorMouseArea.containsMouse ? "#0d9aff" : "#2e3438"
            border.width: 2
            Rectangle {
                x: control.checked ? parent.width - width : 0
                width: parent.height
                height: parent.height
                radius: 20
                color: control.down ? "#cccccc" : "#eeeeee"
                border.color: indicatorMouseArea.containsMouse ? "#0d9aff" : "#2e3438"
            }
            MouseArea {
                id: indicatorMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    control.checked = !control.checked
                    isChecked(control.checked)
                }
            }
        }
    }
}
