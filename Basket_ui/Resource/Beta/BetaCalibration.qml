import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../Components/"

Item {
    id: betaCalibration
    Component.onCompleted: {
        _cppApi_BetaCalibration.init();
    }
    function save() {
        _cppApi_BetaCalibration.onSaveButton()
    }
    function back() {
        _cppApi_BetaCalibration.onBackButton()
        //betaCalibration.
    }
    function started() {
        _cppApi_BetaCalibration.startPressed()
    }
    function stopped() {
        _cppApi_BetaCalibration.stopPressed()
    }

    signal sendTime(var t)
    signal sendStandardDeviation(var sd)
    signal sendCurrentOrCountRateValue(var dr)
    signal sendDoseRateDimension(var dr)
    signal sendAverageDoseRate(var avDR)
    signal sendAverageDoseRateDimension(var avDRd)
    signal sendDose(var d);
    signal sendDoseDimension(var dd);

    Connections {
        target: _cppApi_BetaCalibration
        function onSendTime(t) {
            sendTime(t)
        }
        function onSendStandardDeviation(sd) {
            sendStandardDeviation(sd);
        }
        function onSendCurrentOrCountRateValue(x) {
            sendCurrentOrCountRateValue(x);
        }
        function onSendDimension(dimension) {
            sendDoseRateDimension(dimension);
        }
        function onSendAverageDoseRate(avDR) {
            sendAverageDoseRate(avDR)
        }
        function onSendAverageDoseRateDimension(avDRd) {
            sendAverageDoseRateDimension(avDRd);
        }
        function onSendDose(d) {
            sendDose(d);
        }
        function onSendDoseDimension(dd) {
            sendDoseDimension(dd);
        }
    }
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
        measuredValueDimensionModel: [qsTr("Гр/с"), qsTr("мГр/с"), qsTr("Гр/ч"), qsTr("мГр/ч")]
        sensivityDimension: qsTr("Гр/Кл")
        nuclideInfoVisible: false
    }
}
