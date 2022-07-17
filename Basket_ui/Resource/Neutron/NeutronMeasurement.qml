import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../Components/"

Item {
    id: neutronMeasurement

    // --- Заголовок ---
    StatusBar {
        id: neutronMeasurementStatusBar
        anchors.top: parent.top
        style: StatusBarStyle {
            background: Rectangle {
                color: "#595959"
            }
        }
        Label {
            id: modeLabel
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: neutronMeasurement.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Измерение")
        }
    }

    // --- Окно измерения ---
    Measurement {
        anchors.fill: parent
        deviceType: qsTr("Блок")
        deviceName: qsTr("БДКН-ПБ")
        measuredValueType: qsTr("ПП")
        measuredValueDimension: qsTr("част/см\u00B2с")
        integralValueType: qsTr("Флюенс")
        integralValueDimension: qsTr("част/см\u00B2")
        measurementAutoMode: true
        additionalInfoTitle: measurementAutoMode ? qsTr("Число измерений: ") : ""
        additionalInfo: measurementAutoMode ? qsTr("3") : ""
    }
}
