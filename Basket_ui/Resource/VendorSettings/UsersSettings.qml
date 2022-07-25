import QtQuick 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: userSettings
    property bool emulatorChecked: true

    Component.onCompleted: {
        _cppApi_UserSettings.init()
    }

    Connections {
        target: _cppApi_UserSettings
        function onSetChecked(IsEmulatorOrDetector) {
            if(IsEmulatorOrDetector) {
                userSettings.emulatorChecked = true
            } else {
                userSettings.emulatorChecked = false
            }
        }
    }

    // --- Статус-бар ---
    StatusBar {
        id: userSettingsStatusBar
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
            font.pixelSize: userSettings.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Настройки пользователей")
        }
    }

    // --- Кнопка "Назад" ---

    Rectangle {
        id: backButton
        width: parent.width/4.76
        height: parent.height/3.72
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width/28
        border.width: 2
        border.color: backMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: backText
            width: parent.width*0.8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: backImg.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.2
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Назад")
        }
        Image {
            id: backImg
            height: parent.height/3
            width: parent.width/3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/10
            mirror: true
            source: "qrc:/images/back.png"
        }
        MouseArea {
            id: backMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                _cppApi_UserSettings.onBackButton()
                stackView.pop()
            }
        }
    }

    // --- Кнопка "Изменить пароль поверителя" ---

    Rectangle {
        id: changeVerifierPasswordButton
        width: parent.width/1.62
        height: parent.height/3.87
        anchors.top: backButton.verticalCenter
        anchors.topMargin: parent.height/15
        anchors.left: backButton.right
        anchors.leftMargin: parent.width/21.7
        border.width: 2
        border.color: changeVerifierPasswordMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: changeVerifierPasswordText
            anchors.right: changePasswordImg.left
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.3
            //fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Изменить пароль\nповерителя")
        }
        Image {
            id: changePasswordImg
            height: parent.height/1.5
            width: parent.width/5.73
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.height/12
            source: "qrc:/images/change_password.png"
        }
        MouseArea {
            id: changeVerifierPasswordMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                stackView.push("qrc:/VendorSettings/ChangeVerifierPassword.qml")
            }
        }
    }

    // --- "Приём данных" ---

    Rectangle {
        id: receivingDataFrame
        width: parent.width/1.62
        height: parent.height/3.87
        anchors.bottom: backButton.verticalCenter
        anchors.bottomMargin: parent.height/15
        anchors.left: backButton.right
        anchors.leftMargin: parent.width/21.7
        border.width: 2
        border.color: "#000000"
        radius: 5
        color: "transparent"
        Text {
            id: receivingDataText
            width: parent.width
            height: parent.height/4.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height/18.79
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.2
            //fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Приём данных")
        }
        // --- Кнопки "Эмулятор", "Детектор" ---

        Rectangle {
            id: emulatorRadioButtonRectangle
            width: parent.width/2.43
            height: parent.height/1.88
            anchors.top: receivingDataText.bottom
            anchors.topMargin: parent.height/20
            anchors.left: parent.left
            anchors.leftMargin: parent.width/20
            border.width: 2
            border.color: emulatorRadioButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            Image {
                id: emulatorChecked
                width: height
                height: parent.height/3
                anchors.left: parent.left
                anchors.leftMargin: parent.width/15
                anchors.verticalCenter: parent.verticalCenter
                source: userSettings.emulatorChecked === true ? "qrc:/images/checked.png" : "qrc:/images/not_checked.png"
            }
            Text {
                id: emulatorRadioButtonText
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: emulatorChecked.right
                anchors.leftMargin: parent.width/20
                anchors.right: parent.right
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.4
                //fontSizeMode: Text.Fit
                color: application.fontColor
                text: qsTr("Эмулятор")
            }
            MouseArea {
                id: emulatorRadioButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                   userSettings.emulatorChecked = true
                    _cppApi_UserSettings.onSendChecked(true)
                }
            }
        }

        Rectangle {
            id: detectorRadioButtonRectangle
            width: parent.width/2.43
            height: parent.height/1.88
            anchors.top: receivingDataText.bottom
            anchors.topMargin: parent.height/20
            anchors.right: parent.right
            anchors.rightMargin: parent.width/20
            border.width: 2
            border.color: detectorRadioButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            property bool detectorChecked: true
            Image {
                id: detectorChecked
                width: height
                height: parent.height/3
                anchors.left: parent.left
                anchors.leftMargin: parent.width/15
                anchors.verticalCenter: parent.verticalCenter
                source: userSettings.emulatorChecked === true ? "qrc:/images/not_checked.png" : "qrc:/images/checked.png"
            }
            Text {
                id: detectorRadioButtonText
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: detectorChecked.right
                anchors.leftMargin: parent.width/20
                anchors.right: parent.right
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.4
                //fontSizeMode: Text.Fit
                color: application.fontColor
                text: qsTr("Детектор")
            }
            MouseArea {
                id: detectorRadioButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    userSettings.emulatorChecked = false
                    _cppApi_UserSettings.onSendChecked(false)
                }
            }
        }
    }
}
