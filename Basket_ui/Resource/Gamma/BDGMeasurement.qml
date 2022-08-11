import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../Components/"

Item {
    id: bdgMeasurement

    // --- Заголовок ---
    StatusBar {
        id: bdgMeasurementStatusBar
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
            font.pixelSize: bdgMeasurement.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Измерение")
        }
    }

    // --- Окно измерения ---
    Measurement {
        anchors.fill: parent
        deviceType: qsTr("Блок")
        deviceName: qsTr("БДГ")
        measuredValueType: qsTr("МАЭД")
        measuredValueDimension: qsTr("Гр/с")
        integralValueType: qsTr("Поглощенная доза")
        integralValueDimension: qsTr("Гр")
        measurementAutoMode: false
        additionalInfoTitle: measurementAutoMode ? qsTr("Число измерений: ") : ""
        additionalInfo: measurementAutoMode ? qsTr("3") : ""
    }
}
