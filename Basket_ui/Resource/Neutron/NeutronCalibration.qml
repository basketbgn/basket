import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../Components/"

Item {
    id: neutronCalibration

    // --- Заголовок ---
    StatusBar {
        id: neutronCalibrationStatusBar
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
            font.pixelSize: neutronCalibration.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Калибровка нейтронного блока")
        }
    }

    //Окно калибровки
    Calibration {
        anchors.fill: parent
        deviceType: qsTr("Блок")
        device: qsTr("БДКН-ПБ")
        currentOrCountRateValue: "4.123456E+2"
        currentOrCountRateAndUnit: qsTr("Скорость счёта, имп/с")
        measuredValueOf: qsTr("ПП")
        nameOfMeasuredValue: qsTr("Плотность потока")
        measuredValueDimensionModel: [qsTr("имп/см\u00B2с"), qsTr("...")]
        sensivityDimension: qsTr("(имп/с)/(имп/см\u00B2с)")
        nuclideInfoVisible: false
    }
}
