import QtQuick 2.0
import "../Components"

Item {
    id: bdg

    TransitionWindowToMeasurementAndTest {
        //surname
        //name
        //secondName
        windowTitle: qsTr("БДГ")
        anchors.fill: parent
        onHardwareTestButtonClicked: {
            stackView.push("qrc:/Gamma/BDGHardwareTest.qml")
        }
        onMeasurementButtonClicked: {
            stackView.push("qrc:/Gamma/BDGMeasurementSettings.qml")
        }
    }
}

