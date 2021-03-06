import QtQuick 2.14
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.4
Item {
    id: vendorSettings

    Component.onCompleted: {
        //_cppApi_VendorSettings.createDatabase()
    }

    Connections {
        target: _cppApi_VendorSettings
    }

    // --- Статус-бар ---
    StatusBar {
        id: vendorSettingsStatusBar
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
            font.pixelSize: vendorSettings.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Настройки изготовителя")
        }
    }

    // --- Кнопки: Настройки пользователей, Настройки БДКН, Настройки БДГ, Настройки электрометра ---

    Rectangle {
        id: settingsElectrometerButton
        height: parent.height/2.5
        width: parent.width/3
        anchors.top: vendorSettingsStatusBar.bottom
        anchors.topMargin: parent.height/18
        anchors.right: parent.right
        anchors.rightMargin: parent.width/64
        border.width: 2
        border.color: settingsElectrometerMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: settingsElectrometerText
            width: parent.width*0.8
            height: parent.height/2
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.5
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Настройки\nэлектрометра")
        }
        MouseArea {
            id: settingsElectrometerMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                stackView.push("qrc:/VendorSettings/ElectrometerSettings.qml")
            }
        }
    }

    // --- Кнопка "Настройки пользователей" ---
    Rectangle {
        id: userSettingsButton
        width: settingsElectrometerButton.width
        height: settingsElectrometerButton.height
        anchors.right: settingsElectrometerButton.left
        anchors.rightMargin: parent.width/40
        anchors.top: settingsElectrometerButton.top
        border.width: 2
        border.color: userSettingsMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: userSettingsText
            width: parent.width*0.8
            height: parent.height/2
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.5
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Настройки\nпользователей")
        }
        MouseArea {
            id: userSettingsMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                _cppApi_VendorSettings.onUserSettingsButton()
                stackView.push("qrc:/VendorSettings/UsersSettings.qml")
            }
        }
    }

    // --- Кнопка "Настройки БДГ" ---
    Rectangle {
        id: settingsBDGButton
        width: userSettingsButton.width
        height: userSettingsButton.height
        anchors.left: userSettingsButton.left
        anchors.top: userSettingsButton.bottom
        anchors.topMargin: parent.height/25
        border.width: 2
        border.color: settingsBDGMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: settingsBDGText
            width: parent.width*0.8
            height: parent.height/2
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.5
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Настройки\nБДГ")
        }
        MouseArea {
            id: settingsBDGMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {

            }
        }
    }

    // --- Кнопка "Настройки БДКН" ---
    Rectangle {
        id: settingsBDKNButton
        width: settingsElectrometerButton.width
        height: settingsElectrometerButton.height
        anchors.left: settingsElectrometerButton.left
        anchors.top: settingsBDGButton.top
        border.width: 2
        border.color: settingsBDKNMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        Text {
            id: settingsBDKNText
            width: parent.width*0.8
            height: parent.height/2
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.5
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Настройки\nБДКН")
        }
        MouseArea {
            id: settingsBDKNMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {

            }
        }
    }

    // --- Кнопка "Назад" ---

    Rectangle {
        id: backButton
        width: parent.width/4
        height: parent.height/3
        anchors.verticalCenter: settingsBDGButton.top
        anchors.verticalCenterOffset: -parent.height/50
        anchors.right: settingsBDGButton.left
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
                _cppApi_VendorSettings.onBackButton()
                stackView.pop()
            }
        }
    }
}
