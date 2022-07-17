import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
Item {
    id: changeVerifierPassword

    // --- Заголовок ---
    StatusBar {
        id: changeVerifierPasswordStatusBar
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
            font.pixelSize: changeVerifierPassword.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Смена пароля поверителя")
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
                stackView.pop()
            }
        }
    }

    //--- Поля ввода пароля ---

    Rectangle {
        id: newPasswordTextRectangle
        width: parent.width/2.5
        height: parent.height/8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: parent.width/10
        anchors.top: changeVerifierPasswordStatusBar.bottom
        anchors.topMargin: parent.height/18
        color: "transparent"
        Text {
            id: newPasswordText
            width: parent.width
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.4
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Новый пароль")
        }
    }
    Rectangle {
        id: newPasswordFieldRectangle
        width: newPasswordTextRectangle.width
        height: newPasswordTextRectangle.height
        anchors.left: newPasswordTextRectangle.left
        anchors.top: newPasswordTextRectangle.bottom
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        TextField {
            id: newPasswordField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            passwordCharacter: "\u2B24"
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhDigitsOnly
            validator: RegExpValidator{regExp: /\d{8}/}
            font.pixelSize: parent.height/2.5
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onAccepted: {

            }
        }
    }
    Rectangle {
        id: confirmNewPasswordTextRectangle
        width: newPasswordFieldRectangle.width
        height: newPasswordFieldRectangle.height
        anchors.left: newPasswordFieldRectangle.left
        anchors.top: newPasswordFieldRectangle.bottom
        color: "transparent"
        Text {
            id: confirmNewPasswordText
            width: parent.width
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.4
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Подтвердите пароль")
        }
    }
    Rectangle {
        id: confirmNewPasswordFieldRectangle
        width: confirmNewPasswordTextRectangle.width
        height: confirmNewPasswordTextRectangle.height
        anchors.left: confirmNewPasswordTextRectangle.left
        anchors.top: confirmNewPasswordTextRectangle.bottom
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        TextInput {
            id: confirmNewPasswordField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            passwordCharacter: "\u2B24"
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhDigitsOnly
            validator: RegExpValidator{regExp: /\d{8}/}
            font.pixelSize: parent.height/2.5
            color: application.fontColor
            text: qsTr("")
        }
    }

    //--- Кнопка "Применить" ---

    Rectangle {
        id: confirmButton
        width: confirmNewPasswordFieldRectangle.width
        height: 1.8 * confirmNewPasswordFieldRectangle.height
        anchors.left: confirmNewPasswordFieldRectangle.left
        anchors.top: confirmNewPasswordFieldRectangle.bottom
        anchors.topMargin: parent.height/15
        border.width: 2
        border.color: confirmButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id:confirmText
            width: parent.width*0.8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.3
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Применить")
        }
        MouseArea {
            id: confirmButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if(newPasswordField.text === confirmNewPasswordField.text) {
                    //
                } else {
                    newPasswordField.text = ""
                    confirmNewPasswordField.text = ""
                }
            }
        }
    }

}
