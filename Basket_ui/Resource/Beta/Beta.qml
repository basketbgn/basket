import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: beta
    //  --- fill textFields from database ---
    Component.onCompleted: {
        _cppApi_Beta.initDatabase();
    }
    // in Qml 5.15 there is a new syntax for connections
    Connections {
        target: _cppApi_Beta
        function onTransmitName(name) {
            nameField.text = name
        }
        function onTransmitSurname(surname) {
            surnameField.text = surname
        }
        function onTransmitSecondName(secondName) {
            secondNameField.text = secondName
        }
    }    
    //  old syntax
//    Connections {
//        target: _cppApi
//            onTransmitName: function(name){
//            surnameField.text = name
//        }
//    }

    // --- Pane использую для того, чтобы он ловил фокус при клике вне полей ввода, таким образом и само поле ввода будет терять фокус ---
    Pane {
        background: Rectangle {
            color: "transparent"
        }
        anchors.fill: parent
        z: -10
        focusPolicy: Qt.ClickFocus
    }

    // --- Статус-бар = Заголовок ---
    StatusBar {
        id: betaStatusBar
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
            font.pixelSize: beta.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Бета излучение")
        }
    }

    // --- ФИО ---
        //--- Имя ---
    Text {
        id: nameText
        width: parent.width/3.5
        height: parent.height/15
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: betaStatusBar.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height*0.4
        fontSizeMode: Text.Fit
        color: application.fontColor
        text: qsTr("Имя")
    }
    Rectangle {
        id: name
        signal sendName(var str)
        width: parent.width/3.5
        height: parent.height/10
        anchors.top: nameText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        TextField {
            id: nameField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/2.5
            maximumLength: 16
            color: application.fontColor
            placeholderText: qsTr("Иван")
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
//            onAccepted: {
//                name.sendName(text)
//                _cppApi.cppSlot(text)
//            }
            onTextChanged: {
                _cppApi_Beta.onNameChanged(text)
            }
        }
    }
        //--- Фамилия ---
    Text {
        id: surnameText
        width: parent.width/3.5
        height: parent.height/15
        anchors.top: betaStatusBar.bottom
        anchors.right: nameText.left
        anchors.rightMargin: parent.width/25
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height*0.4
        fontSizeMode: Text.Fit
        color: application.fontColor
        text: qsTr("Фамилия")
    }
    Rectangle {
        id: surname
        width: parent.width/3.5
        height: parent.height/10
        anchors.top: nameText.bottom
        anchors.right: name.left
        anchors.rightMargin: parent.width/25
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        TextField {
            id: surnameField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/2.5
            maximumLength: 16
            color: application.fontColor
            placeholderText: qsTr("Иванов")
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onAccepted: {

            }
            onTextChanged: {
                _cppApi_Beta.onSurnameChanged(text)
            }
        }
    }
        //--- Отчество ---
    Text {
        id: secondNameText
        width: parent.width/3.5
        height: parent.height/15
        anchors.top: betaStatusBar.bottom
        anchors.left: nameText.right
        anchors.leftMargin: parent.width/25
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height*0.4
        fontSizeMode: Text.Fit
        color: application.fontColor
        text: qsTr("Отчество")
    }
    Rectangle {
        id: secondName
        width: parent.width/3.5
        height: parent.height/10
        anchors.top: nameText.bottom
        anchors.left: name.right
        anchors.leftMargin: parent.width/25
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        TextField {
            id: secondNameField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/2.5
            maximumLength: 16
            color: application.fontColor
            placeholderText: qsTr("Иванович")
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onAccepted: {

            }
            onTextChanged: {
                _cppApi_Beta.onSecondNameChanged(text)
            }
        }
    }

    // --- Кнопка "Тест аппаратуры" ---

    Rectangle {
        id: hardwareTestButton
        width: parent.width/2.8
        height: parent.height/2.6
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: parent.width/25
        border.width: 2
        border.color: hardwareTestMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: hardwareTestText
            width: parent.width*0.8
            height: parent.height/2
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.15
            //fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Тест аппаратуры")
        }
        MouseArea {
            id: hardwareTestMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                stackView.push("qrc:/Beta/BetaHardwareTest.qml")
            }
        }
    }

    // --- Кнопка "Измерение" ---

    Rectangle {
        id: measurementButton        
        width: parent.width/2.8
        height: parent.height/2.6
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: parent.width/25
        border.width: 2
        border.color: measurementMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: measurementText
            width: parent.width*0.8
            height: parent.height/2
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.15
            //fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Измерение")
        }
        MouseArea {
            id: measurementMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                _cppApi_Beta.onMeasurementButton()
                stackView.push("qrc:/Beta/BetaMeasurementSettings.qml")
            }
        }
    }

    // --- Кнопка "Назад" ---

    Rectangle {
        id: backButton

        signal signalBackButton()
        width: parent.width/3
        height: parent.height/5
        anchors.top: hardwareTestButton.bottom
        anchors.topMargin: parent.height/20
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 2
        border.color: backMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Image {
            id: backImg
            height: parent.height/2
            width: parent.width/5.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: backText.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/25
            mirror: true
            source: "qrc:/images/back.png"
        }
        Text {
            id: backText
            width: parent.width*0.8
            height: parent.height/2
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.3
            color: application.fontColor
            text: qsTr("Назад")
        }
        MouseArea {
            id: backMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                _cppApi_Beta.onBackButton()
                stackView.pop()
            }
        }
    }
}
