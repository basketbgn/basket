import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../Components/"

Item {
    id: betaCalibration

    // --- Статус-бар = Заголовок ---
    StatusBar {
        id: betaCalibrationStatusBar
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
            font.pixelSize: betaCalibration.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Калибровка бета-камеры")
        }
    }

    // --- Окно калибровки ---
    Calibration {
        anchors.fill: parent
        deviceType: qsTr("Камера")
        device: qsTr("ИКБ1")
        currentOrCountRateValue: "4.123456E-10"
        currentOrCountRateAndUnit: qsTr("Ток, А")
        measuredValueOf: qsTr("МПД")
        measuredValueDimensionModel: [qsTr("Гр/с"), qsTr("...")]
        sensivityDimension: qsTr("Гр/Кл")
        nuclideInfoVisible: false
    }
}
