import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import "../Components"
Item {
    id: ionizationChambersCalibration
    // --- Заголовок ---
    StatusBar {
        id: ionizationChambersCalibrationStatusBar
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
            font.pixelSize: ionizationChambersCalibration.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Калибровка ионизационной камеры")
        }
    }

    //Окно калибровки
    Calibration {
        anchors.fill: parent
        deviceType: qsTr("Камера")
        device: qsTr("ИКГ-50")
        currentOrCountRateValue: "4.123456E+2"
        currentOrCountRateAndUnit: qsTr("Ток, А")
        measuredValueOf: qsTr("МАЭД")
        nameOfMeasuredValue: qsTr("Мощность амбиентного эквивалента дозы")
        measuredValueDimensionModel: [qsTr("Зв/ч"), qsTr("мЗв/ч"), qsTr("мкЗв/ч"), qsTr("Зв/с"), qsTr("мЗв/с"), qsTr("мкЗв/с"),]
        sensivityDimension: qsTr("Зв/Кл")
        nuclideInfoVisible: false
    }
}
