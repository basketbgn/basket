import QtQuick 2.0
import "../Components"

Item {
    id: neutron

    TransitionWindowToMeasurementAndTest {
        //surname
        //name
        //secondName
        windowTitle: qsTr("Нейтронное излучение")
        anchors.fill: parent
        onHardwareTestButtonClicked: {
            stackView.push("qrc:/Neutron/NeutronHardwareTest.qml")
        }
        onMeasurementButtonClicked: {
            stackView.push("qrc:/Neutron/NeutronMeasurementSettings.qml")
        }
    }
}
