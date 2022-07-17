import QtQuick 2.14
import QtQuick.Controls 2.12
Item {
    id: mainPage

    function checkCode(codeString) { //тестовая функция проверки пароля
        if(codeString === "777") {
            accessCodeButton.back = !accessCodeButton.back
            accessCodeInput.visible = accessCodeButton.back
            accessIndicator.visible = !accessCodeButton.back
            vendorSettingsButton.visible = true
            verifierSettingsButton.visible = true
            userTypeText.text = qsTr("Изготовитель")
        } else {
            vendorSettingsButton.visible = false
            verifierSettingsButton.visible = false
            userTypeText.text = qsTr("Оператор")
        }
        accessCodeField.text = qsTr("")
    }

    // --- Надпись "Выберите вид измеряемого излучения" ---

    Rectangle {
        id: instructionIndicator
        anchors.left: betaRadiationButton.left
        anchors.right: neutronRadiationButton.right
        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: vendorSettingsButton.bottom
        anchors.bottom: gammaRadiationButton.top
        color: "transparent"
        Text {
            id: instructionText
            width: parent.width*0.9
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: parent.height*0.6
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Выберите тип измеряемого излучения")

        }
    }

    // --- Кнопки выбора режима измерений ---

    // --- Кнопка "Бета излучение" ---
    Rectangle {
        id: betaRadiationButton
        width: gammaRadiationButton.width
        height: gammaRadiationButton.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: gammaRadiationButton.left
        anchors.rightMargin: parent.width/64
        border.width: 2
        border.color: betaRadiationMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: betaRadiationText
            width: parent.width*0.9
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height/35
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height/9
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Бета\nизлучение")
        }
        Image {
            id: betaImg
            width: parent.width/3
            height: parent.height/3
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            source: "qrc:/images/beta.png"
        }
        MouseArea {
            id: betaRadiationMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                stackView.push("qrc:/Beta/Beta.qml")
            }
        }
    }

    // --- Кнопка "Гамма излучение" ---
    Rectangle {
        id: gammaRadiationButton
        width: (parent.width - parent.width/16) / 3
        height: parent.height/2
        anchors.centerIn: parent
        border.width: 2
        border.color: gammaRadiationMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: gammaRadiationText
            width: parent.width*0.9
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height/35
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height/9
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Гамма\nизлучение")
        }
        Image {
            id: gammaImg
            width: parent.width/3
            height: parent.height/3
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            source: "qrc:/images/gamma.png"
        }
        MouseArea {
            id: gammaRadiationMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {

            }
        }
    }

    // --- Кнопка "Нейтронное излучение" ---
    Rectangle {
        id: neutronRadiationButton
        width: betaRadiationButton.width
        height: betaRadiationButton.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: gammaRadiationButton.right
        anchors.leftMargin: parent.width/64
        border.width: 2
        border.color: neutronRadiationMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: neutronRadiationText
            width: parent.width*0.9
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height/35
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height/9
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Нейтронное\nизлучение")
        }
        Image {
            id: neutronImg
            width: parent.width/3
            height: parent.height/3
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            source: "qrc:/images/neutron.png"
        }
        MouseArea {
            id: neutronRadiationMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                stackView.push("qrc:/Neutron/Neutron.qml")
            }
        }
    }

    // --- Кнопка настроек изготовителя ---
    Rectangle {
        id: vendorSettingsButton
        width: gammaRadiationButton.width
        height: (parent.height/2 - gammaRadiationButton.height/2) - parent.height/12
        anchors.horizontalCenter: gammaRadiationButton.horizontalCenter
        anchors.bottom: gammaRadiationButton.top
        anchors.bottomMargin: parent.height/16
        border.width: 2
        border.color: vendorSettingsMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        visible: false
        Text {
            id: vendorSettingsText
            width: parent.width*0.9
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height/25
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height/4
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Настройки\nизготовителя")
        }
        Image {
            id: vendorSettingsImg
            width: parent.width/4
            height: width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/10
            anchors.right: parent.right
            anchors.rightMargin: parent.width/25
            source: "qrc:/images/settings.png"
        }
        MouseArea {
            id: vendorSettingsMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                stackView.push("qrc:/VendorSettings/VendorSettings.qml")
            }
        }
    }

    // --- Кнопка настроек поверителя ---
    Rectangle {
        id: verifierSettingsButton
        width: betaRadiationButton.width
        height: (parent.height/2 - betaRadiationButton.height/2) - parent.height/12
        anchors.horizontalCenter: betaRadiationButton.horizontalCenter
        anchors.bottom: betaRadiationButton.top
        anchors.bottomMargin: parent.height/16
        border.width: 2
        border.color: verifierSettingsMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        visible: false
        Text {
            id: verifierSettingsText
            width: parent.width*0.9
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height/25
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height/4
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Настройки\nповерителя")
        }
        Image {
            id: verifierSettingsImg
            width: parent.width/5
            height: width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/10
            anchors.right: parent.right
            anchors.rightMargin: parent.width/25
            source: "qrc:/images/settings_one_gear.png"
        }
        MouseArea {
            id: verifierSettingsMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                stackView.push("qrc:/VerifierSettings/VerifierSettings.qml")
            } 
        }
    }


    // --- Кнопка выхода/завершения программы ---
    Rectangle {
        id: exitButton
        objectName: "exitButton"
        width: neutronRadiationButton.width
        height: (parent.height/2 - neutronRadiationButton.height/2) - parent.height/12
        anchors.horizontalCenter: neutronRadiationButton.horizontalCenter
        anchors.bottom: neutronRadiationButton.top
        anchors.bottomMargin: parent.height/16
        border.width: 2
        border.color: exitButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        signal signalExitButton()
        Text {
            id: exitText
            width: parent.width*0.9
            anchors.left: parent.left
            anchors.right: exitImg.left
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height/3.5
            font.bold: true
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Выход")
        }
        Image {
            id: exitImg
            width: parent.width/4
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width/25
            source: "qrc:/images/exit.png"
        }
        MouseArea {
            id: exitButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                //Qt.quit()
                exitButton.signalExitButton();
            }
        }
    }

    // --- Индикатор уровня доступа пользователя ---
    Rectangle {
        id: accessIndicator
        width: neutronRadiationButton.width
        height: (parent.height/2 - betaRadiationButton.height/2) - parent.height/12
        anchors.right: neutronRadiationButton.right
        anchors.top: betaRadiationButton.bottom
        anchors.topMargin: parent.height/24
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: "transparent"
        Text {
            id: accessText
            height: parent.height/2
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: parent.width/20
            anchors.right: userImg.left
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height/3.5
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Доступ:")
        }
        Text {
            id: userTypeText
            height: parent.height/2
            anchors.top: accessText.bottom
            anchors.left: parent.left
            anchors.leftMargin: parent.width/20
            anchors.right: userImg.left
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            font.pixelSize: parent.height/3.5
            font.bold: true
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Оператор")
        }
        Image {
            id: userImg
            width: parent.width/5
            height: parent.height/1.5
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width/25
            source: "qrc:/images/user_icon.png"
        }
    }

    // --- Кнопка ввода кода доступа ---

    Rectangle {
        id: accessCodeButton
        width: betaRadiationButton.width
        height: (parent.height/2 - betaRadiationButton.height/2) - parent.height/12
        anchors.horizontalCenter: betaRadiationButton.horizontalCenter
        anchors.top: betaRadiationButton.bottom
        anchors.topMargin: parent.height/24
        border.width: 2
        border.color: accessCodeMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        property bool back: false
        Text {
            id: accessCodeText
            anchors.left: parent.left
            anchors.leftMargin: parent.width/10
            anchors.right: arrowImg.left
            anchors.rightMargin: parent.width/10
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.back ? parent.height*0.4 : parent.height*0.7
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: parent.back ? qsTr("Отмена") : qsTr("Ввести код\nдоступа")
        }
        Image {
            id: arrowImg
            width: parent.width/5
            height: width*1.2
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width/25
            mirror: parent.back
            source: "qrc:/images/arrow.png"
        }
        MouseArea {
            id: accessCodeMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                accessIndicator.visible = parent.back
                accessCodeInput.visible = !parent.back
                parent.back = !parent.back
            }
        }
    }

    // --- Поле ввода кода доступа ---

    Rectangle {
        id: accessCodeInput
        width: gammaRadiationButton.width
        height: (parent.height/2 - gammaRadiationButton.height/2) - parent.height/12
        anchors.horizontalCenter: gammaRadiationButton.horizontalCenter
        anchors.top: gammaRadiationButton.bottom
        anchors.topMargin: parent.height/24
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: false
        TextField {
            id: accessCodeField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            passwordCharacter: "\u2B24"
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhDigitsOnly
            validator: RegExpValidator{regExp: /\d{8}/}
            font.pixelSize: parent.height/3.5
            //cursorVisible: true
            color: application.fontColor
            text: qsTr("")
            placeholderText: "пароль"
            background: Rectangle {
                color: "transparent"
            }
            onVisibleChanged: {
                if(!visible) focus = false
            }
            onAccepted: {
                mainPage.checkCode(text)
            }
        }
    }

    // --- Кнопка подтверждения кода доступа ---

    Rectangle {
        id: accessCodeSubmitButton
        objectName: "accessCodeSubmitButton"
        width: neutronRadiationButton.width
        height: accessCodeInput.height
        anchors.left: neutronRadiationButton.left
        anchors.top: accessCodeInput.top
        border.width: 2
        border.color: accessCodeSubmitMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        visible: accessCodeInput.visible
        signal signalAccessCodeSubmitButton(string str)
        Text {
            id: approveText
            height: parent.height
            width: 1.8*parent.width/3
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: application.fontColor
            font.pixelSize: height*0.5
            text: qsTr("Ввод")
        }
        Image {
            id: enterImg
            height: parent.height*0.9
            width: height
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: approveText.right
            source: "qrc:/images/enter.png"
        }
        MouseArea {
            id: accessCodeSubmitMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                //accessCodeField.accepted()
                accessCodeSubmitButton.signalAccessCodeSubmitButton(accessCodeField.text)
            }
        }
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.1;height:480;width:640}
}
##^##*/
