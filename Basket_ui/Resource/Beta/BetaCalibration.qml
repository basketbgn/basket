import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1
import "../Components/"

Item {
    id: betaCalibration

    Timer {
        id: timerCount100ms
        interval: 100; running: true; repeat: true
        onTriggered: {
            messageDialog.time++
        }
    }
    Timer {
        interval: 2000; running: true; repeat: false
        onTriggered: {
            timerCount100ms.repeat = false
            messageDialog.standardButtons = StandardButton.Ok
        }
    }
    MessageDialog {
        id: messageDialog
        property var time: 0
        icon: StandardIcon.Critical
        modality: Qt.WindowModal
        standardButtons : MessageDialog.NoButton
        title: "ВНИМАНИЕ"
        text: "Введите значение Мощности Поглощенной Дозы\n
                в даннной точке измерения и нажмите старт\n\n
                При нажатии кнопки стоп выведется значение чувствительности,
                которое необходимо записать "
        informativeText: time
        onAccepted: {
        }
        Component.onCompleted: {
            visible = true
        }
    }
    MessageDialog {
        id: messageDialogWarning
        icon: StandardIcon.Information
        modality: Qt.WindowModal
        standardButtons : MessageDialog.Ok
        title: "ВНИМАНИЕ"
        text: "Указаны не все параметры, запись отменена"
        onAccepted: {
        }
        Component.onCompleted: {
            visible = false
        }
    }

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
    function sendTextToCpp(str) {
        _cppApi_BetaCalibration.onSendDoseRate(str)
    }
    function sendCurrentIndexToCpp(i) {
        _cppApi_BetaCalibration.onSendCurrentIndex(i)
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
        function onSendSensibilityToQml(sens) {
            betaCalibrationCalibration.sensivity = sens
        }
        function onSendAverageDoseRateDimension(avDRd) {
            sendAverageDoseRateDimension(avDRd);
        }
        function onSendWarningMsg() {
            messageDialogWarning.visible = true
        }
        function onSendDoseDimension(dd) {
            sendDoseDimension(dd);
        }
        function onSendListModel(x, y) {
            betaCalibrationCalibration.measuredValueDimensionModel = x;
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
        id: betaCalibrationCalibration
        anchors.fill: parent
        deviceType: qsTr("Камера")
        device: qsTr("ИКБ1")
        currentOrCountRateValue: "4.123456E-10"
        currentOrCountRateAndUnit: qsTr("Ток, А")
        measuredValueOf: qsTr("МПД")
        measuredValueDimensionModel: []//listModel///[qsTr("Гр/с"), qsTr("мГр/с"), qsTr("Гр/ч"), qsTr("мГр/ч")]
        sensivityDimension: qsTr("Гр/Кл")
        sensivity: ""
        nuclideInfoVisible: false
    }
}
