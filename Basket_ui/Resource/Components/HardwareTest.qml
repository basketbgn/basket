import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1

Item {
    //Тест аппаратуры
    id: hardwareTest

    Component.onCompleted: {
        _cppApi_ElectrometerTest.init();
    }

    Connections {
        target: _cppApi_ElectrometerTest
        function onClose(){
            stackView.pop()
        }
        function onProgressBarSetValue(x){
            percentValue.text = x + "%"
            progressBar.value = x/100
        }
        function onProcedureName(str){
            procedure.text = str
        }
        function onSendADC(str) {
            adcText.text = str
        }
        function onSendADC_V(str) {
            adcVText.text = str
        }
        function onSendTime(t) {
            timeValue.value = t
        }
        function onSendHardwareFault() {
            messageDialogHardwareFault.visible = true;
        }
        function onSendTestResult(str){
            messageDialogTestResult.text = str
            messageDialogTestResult.visible = true;
        }
        function onSendTestPassedToQml(state) {
            messageDialogTestResult.isTestPassed = state
        }
    }

    property alias procedureType: procedure.text //Тип процедуры (прогрев и т.п.)

    property alias adcFieldValue: adcText.text // Для меня не совсем понятно назначение этого поля

    property alias adcVoltageFieldValue: adcVText.text //Значение АЦП напряжения

    property alias progressBarValue: progressBar.progressBarValue // Значение прогресс-бара от 0 до 1

    property alias timeValue: timeValue.value //Время в секундах

    property alias testResult: resultText.text //Результат теста

    MessageDialog {
        id: messageDialogHardwareFault
        icon: StandardIcon.Critical
        modality: Qt.WindowModal
        standardButtons : MessageDialog.Ok
        title: "ВНИМАНИЕ"
        text: "Нет информации с детектора, \n необходим ремонт!!!"
        onAccepted: {
            stackView.pop()
        }
        Component.onCompleted: {
            visible = false
        }
    }
    MessageDialog {
        id: messageDialogTestResult
        property bool isTestPassed: false
        icon: StandardIcon.Information
        modality: Qt.WindowModal
        standardButtons : MessageDialog.Ok
        title: "ВНИМАНИЕ"
        text: "Указаны не все параметры, запись отменена"
        onAccepted: {
            stackView.pop()
            _cppApi_ElectrometerTest.onClose()
        }
        Component.onCompleted: {
            visible = false
        }
    }

    // --- Заголовок ---
    StatusBar {
        id: hardwareTestStatusBar
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
            font.pixelSize: hardwareTest.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Тест аппаратуры")
        }
    }

    // --- Тип процедуры (прогрев, ...) ---
    Text {
        id: procedure
        width: parent.width/3
        height: parent.height/20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: hardwareTestStatusBar.bottom
        anchors.topMargin: parent.height/60
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.height/35
        color: application.fontColor
        text: qsTr("Процедура")
    }

    // --- Поля отображения параметров АЦП (?) ---
    Text {
        id: adcTitle
        height: adcRectangle.height
        anchors.verticalCenter: adcRectangle.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width/10
        anchors.right: adcRectangle.left
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: application.fontColor
        font.pixelSize: parent.height/20
        text: qsTr("АЦП")
    }
    Rectangle {
        id: adcRectangle
        width: parent.width/2
        height: parent.height/15
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: procedure.bottom
        anchors.topMargin: parent.height/20
        color: "transparent"
        //border.width: 2
        //border.color: "#eeeeee"
        Text {
            id: adcText
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: application.fontColor
            font.pixelSize: parent.height*0.7
            text: qsTr("123456")
        }
        Rectangle {
            width: parent.width
            height: 1
            color: application.fontColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }
    }

    Text {
        id: adcVTitle
        height: adcVRectangle.height
        anchors.verticalCenter: adcVRectangle.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width/10
        anchors.right: adcVRectangle.left
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: application.fontColor
        font.pixelSize: parent.height/20
        text: qsTr("АЦП, В")
    }
    Rectangle {
        id: adcVRectangle
        width: parent.width/2
        height: parent.height/15
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: adcRectangle.bottom
        anchors.topMargin: parent.height/15
        color: "transparent"
        //border.width: 2
        //border.color: "#eeeeee"
        Text {
            id: adcVText
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: application.fontColor
            font.pixelSize: parent.height*0.7
            text: qsTr("123456")
        }
        Rectangle {
            width: parent.width
            height: 1
            color: application.fontColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }
    }

    // --- Прогресс-бар  ---
    Rectangle {
        id: progressBarRectangle
        width: parent.width/2
        height: parent.height/6
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: adcVRectangle.bottom
        anchors.topMargin: parent.height/15
        color: "transparent"
        visible: true

        Text {
            id: time
            width: parent.width/2
            height: parent.height/2
            anchors.top: parent.top
            anchors.left: parent.left
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: parent.height*0.3
            color: application.fontColor
            text: qsTr("Время: ")
        }
        Text {
            id: timeValue //секунды
            property int value: 0
            width: parent.width/2
            height: parent.height/2
            anchors.left: time.right
            anchors.verticalCenter: time.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: parent.height*0.3
            color: "#28FF00"
            text: value + qsTr(" с")
        }

        ProgressBarWithPercents {
            id: progressBar
            height: parent.height/2
            width: parent.width
            anchors.top: time.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            progressBarValue: 0.0
        }
    }

    //Результат теста аппаратуры
    Rectangle {
        id: resultRectangle
        width: adcRectangle.width
        anchors.top: adcVRectangle.bottom
        anchors.bottom: cancelButton.top
        anchors.topMargin: parent.height/30
        anchors.bottomMargin: parent.height/50
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        border.width: 2
        border.color: "#eeeeee"
        visible: false
        Text {
            id: resultTitle
            width: parent.width
            height: parent.height/8
            anchors.top: parent.top
            anchors.topMargin: parent.height/30
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height*0.9
            color: application.fontColor
            text: qsTr("Результат")
        }
        Text {
            id: resultText
            width: parent.width*0.9
            anchors.top: resultTitle.bottom
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height/10
            color: application.fontColor
            wrapMode: Text.Wrap
            text: qsTr("abcdefghijklmnopqrstuvwxyzzyxwvutsrqponmlkjihgfedcba")
        }
    }


    // --- Кнопка "Отмена" ---
    CustomButton {
        id: cancelButton
        width: parent.width/5
        height: parent.height/6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height/30
        anchors.horizontalCenter: parent.horizontalCenter
        buttonFontSizeCoef: 0.35
        buttonText: qsTr("Отмена")
        onButtonClicked: {
            _cppApi_ElectrometerTest.onCancelButton()
            stackView.pop()
        }
    }
    // --- Кнопка "Отмена" ---
    /*Rectangle {
        id: cancelButton
        width: parent.width/5
        height: parent.height/6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height/30
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 2
        border.color: cancelMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: cancelText
            width: parent.width*0.8
            height: parent.height/2
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.4
            color: application.fontColor
            text: qsTr("Отмена")
        }
        MouseArea {
            id: cancelMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                _cppApi_ElectrometerTest.onCancelButton()
                stackView.pop()
            }
        }
    }*/
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.66;height:800;width:1280}
}
##^##*/
