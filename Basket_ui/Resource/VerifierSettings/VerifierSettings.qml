import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
import "../Components"

Item {
    id: verifierSettings

    // --- Статус-бар ---
    StatusBar {
        id: verifierSettingsStatusBar
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
            font.pixelSize: verifierSettings.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Настройки поверителя")
        }
    }

    // --- Кнопки: Бета излучение (ИК), Гамма излучение (ИК), Гамма излучение (БДГ), Нейтронное излучение (БДКН) ---
    CustomButton {
        id: gammaIKButton
        height: parent.height/2.5
        width: parent.width/3
        anchors.top: checksumDisplay.bottom
        anchors.topMargin: parent.height/35
        anchors.right: parent.right
        anchors.rightMargin: parent.width/64
        buttonFontSizeCoef: 0.15
        buttonText: qsTr("Гамма\nизлучение\n(ИК)")
        onButtonClicked: {
            stackView.push("qrc:/VerifierSettings/VerifierGammaIK.qml")
        }
    }

    CustomButton {
        id: betaIKButton
        width: gammaIKButton.width
        height: gammaIKButton.height
        anchors.right: gammaIKButton.left
        anchors.rightMargin: parent.width/40
        anchors.top: gammaIKButton.top
        buttonFontSizeCoef: 0.15
        buttonText: qsTr("Бета\nизлучение\n(ИК)")
        onButtonClicked: {
            stackView.push("qrc:/VerifierSettings/VerifierBetaIK.qml")
        }
    }

    CustomButton {
        id: gammaBDGButton
        width: betaIKButton.width
        height: betaIKButton.height
        anchors.left: betaIKButton.left
        anchors.top: betaIKButton.bottom
        anchors.topMargin: parent.height/25
        buttonFontSizeCoef: 0.15
        buttonText: qsTr("Гамма\nизлучение\n(БДГ)")
        onButtonClicked: {
            stackView.push("qrc:/VerifierSettings/VerifierGammaBDG.qml")
        }
    }

    CustomButton {
        id: neutronButton
        width: betaIKButton.width
        height: betaIKButton.height
        anchors.left: gammaIKButton.left
        anchors.top: gammaBDGButton.top
        buttonFontSizeCoef: 0.15
        buttonText: qsTr("Нейтронное\nизлучение\n(БДКН)")
        onButtonClicked: {
            stackView.push("qrc:/VerifierSettings/VerifierNeutronBDKN.qml")
        }
    }

    // --- Поле отображения контрольной суммы ---

    Rectangle {
        id: checksumDisplay
        height: parent.height/20
        //width: parent.width*0.8
        anchors.top: verifierSettingsStatusBar.bottom
        anchors.topMargin: parent.height/50
        anchors.left: betaIKButton.left
        anchors.right: gammaIKButton.right
        radius: 5
        color: "transparent"
        visible: true
        Text {
            id: checksumValue
            height: parent.height
            width: parent.width*0.9
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.7
            fontSizeMode: Text.Fit
            color: application.fontColor
            font.underline: true
            text: qsTr("Контрольная сумма = 357440a83580e9baa84842d65667495d")
        }
    }

    // --- Кнопка "Назад" ---

    Rectangle {
        id: backButton
        width: parent.width/4
        height: parent.height/3
        anchors.verticalCenter: gammaBDGButton.top
        anchors.verticalCenterOffset: -parent.height/50
        anchors.right: betaIKButton.left
        anchors.rightMargin: parent.width/45
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
}
