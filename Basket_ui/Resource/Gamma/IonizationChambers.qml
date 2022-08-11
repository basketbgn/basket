import QtQuick 2.0
import "../Components"

Item {
    id: ionizationChambers

    TransitionWindowToMeasurementAndTest {
        //surname
        //name
        //secondName
        windowTitle: qsTr("Ионизационные камеры")
        anchors.fill: parent
        onHardwareTestButtonClicked: {
            stackView.push("qrc:/Gamma/IonizationChambersHardwareTest.qml")
        }
        onMeasurementButtonClicked: {
            stackView.push("qrc:/Gamma/IonizationChambersMeasurementSettings.qml")
        }
    }
}

