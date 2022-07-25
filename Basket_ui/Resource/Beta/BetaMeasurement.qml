import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../Components/"

Item {
    id: betaMeasurement
    signal sendTime(var t)
    signal sendStandardDeviation(var sd)
    signal sendDoseRate(var dr)
    signal sendDoseRateDimension(var dr)
    signal sendAverageDoseRate(var avDR)
    signal sendAverageDoseRateDimension(var avDRd)
    signal sendDose(var d);
    signal sendDoseDimension(var dd);

    function back() {
        _cppApi_BetaMeasurement.onBackButton()
    }
    function started() {
        _cppApi_BetaMeasurement.startPressed()
    }
    function stopped() {
        _cppApi_BetaMeasurement.stopPressed()
    }

    Component.onCompleted: {
        _cppApi_BetaMeasurement.init();
    }
    // in Qml 5.15 there is a new syntax for connections
    Connections {
        target: _cppApi_BetaMeasurement
        function onSendTime(t) {            
            sendTime(t)
        }
        function onSendStandardDeviation(sd) {
            sendStandardDeviation(sd);
        }
        function onSendDoseRate(dr) {
            sendDoseRate(dr);
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

    // --- Заголовок ---
    StatusBar {
        id: betaMeasurementStatusBar
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
            font.pixelSize: betaMeasurement.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Измерение")
        }
    }

    // --- Окно измерения ---
    Measurement {
        anchors.fill: parent
        deviceType: qsTr("Камера")
        deviceName: qsTr("ИКБ-1")
        measuredValueType: qsTr("МПД")
        measuredValueDimension: qsTr("Гр/с")
        integralValueType: qsTr("Поглощенная доза")
        integralValueDimension: qsTr("Гр")
        measurementAutoMode: false
        additionalInfoTitle: measurementAutoMode ? qsTr("Число измерений: ") : ""
        additionalInfo: measurementAutoMode ? qsTr("3") : ""
    }
}
