import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../Components/"

Item {
    id: gamma
    // --- Статус-бар = Заголовок ---
    StatusBar {
        id: gammaStatusBar
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
            font.pixelSize: gamma.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Гамма излучение")
        }
    }

    CustomButton {
        id: bdgButton
        width: parent.width/2.6
        height: parent.height/2.2
        anchors.top: gammaStatusBar.bottom
        anchors.topMargin: parent.height/8
        anchors.left: parent.left
        anchors.leftMargin: parent.width/14
        buttonText: qsTr("БДГ")
        buttonFontSizeCoef: 0.15
        onButtonClicked: {
            stackView.push("qrc:/Gamma/BDG.qml")
        }
    }

    CustomButton {
        id: ionizationChambersButton
        width: parent.width/2.6
        height: parent.height/2.2
        anchors.top: bdgButton.top
        anchors.right: parent.right
        anchors.rightMargin: parent.width/14
        buttonText: qsTr("Ионизационные\nкамеры")
        buttonFontSizeCoef: 0.15
        onButtonClicked: {
            stackView.push("qrc:/Gamma/IonizationChambers.qml")
        }
    }

    CustomButton {
        id: backButton
        width: parent.width/3
        height: parent.height/4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height/20
        anchors.horizontalCenter: parent.horizontalCenter
        buttonText: qsTr("Назад")
        buttonFontSizeCoef: 0.3
        onButtonClicked: {
            stackView.pop()
        }
    }
}
