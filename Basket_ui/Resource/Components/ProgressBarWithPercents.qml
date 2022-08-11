import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4

Item {
    width: 200
    height: 50
    property alias progressBarValue: progressBar.value
    ProgressBar {
        id: progressBar
        height: parent.height
        width: parent.width
        anchors.centerIn: parent
        value: 0.65
        Text {
            id: percentValue
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: parent.height*0.65
            color: "#333333"
            text: parent.value*100 + "%"
        }
    }
}
