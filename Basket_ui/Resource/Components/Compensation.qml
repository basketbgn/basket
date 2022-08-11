import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Item {
    id: compensation
    width: 1280
    height: 800

    /*
      Здесь должны быть свойства компонента
    */

    // --- Заголовок ---
    StatusBar {
        id: compensationStatusBar
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
            font.pixelSize: compensation.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Компенсация токов утечки с камерой")
        }
    }

    // --- Главная ---
    Pane {
        id: mainLayer
        anchors.fill: parent
        background: Rectangle {
            color: "transparent"
        }
        focusPolicy: Qt.ClickFocus
        visible: true

        // --- Главная ---
        Row {
            id: rowOfTitles
            width: parent.width*0.95
            height: parent.height/15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height/7.14 + compensationStatusBar.height
            Text {
                id: sensitiveTitle
                height: parent.height
                width: parent.width/3
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: height*0.6
                color: application.fontColor
                text: qsTr("Чувствительный, В")
            }

            Text {
                id: middleTitle
                height: parent.height
                width: parent.width/3
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: height*0.6
                color: application.fontColor
                text: qsTr("Средний, В")
            }

            Text {
                id: roughTitle
                height: parent.height
                width: parent.width/3
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: height*0.6
                color: application.fontColor
                text: qsTr("Грубый, В")
            }

        }

        Row {
            id: rowOfValues
            width: rowOfTitles.width
            height: rowOfTitles.height*2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rowOfTitles.bottom
            Text {
                id: sensitiveValue
                height: parent.height
                width: parent.width/3
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: height*0.5
                color: application.fontColor
                text: qsTr("123.4567")
                Rectangle {
                    width: parent.width*0.9
                    height: 1
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: application.fontColor
                }
            }

            Text {
                id: middleValue
                height: parent.height
                width: parent.width/3
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: height*0.5
                color: application.fontColor
                text: qsTr("123.4567")
                Rectangle {
                    width: parent.width*0.9
                    height: 1
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: application.fontColor
                }
            }

            Text {
                id: roughValue
                height: parent.height
                width: parent.width/3
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: height*0.5
                color: application.fontColor
                text: qsTr("123.4567")
                Rectangle {
                    width: parent.width*0.9
                    height: 1
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: application.fontColor
                }
            }

        }

        // --- Кнопка "Выполнить компенсацию" ---
        CustomButton {
            id: startCompensationButton
            width: parent.width/2.16
            height: parent.height/5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rowOfValues.bottom
            anchors.topMargin: parent.height/10
            buttonText: qsTr("Выполнить компенсацию")
            onButtonClicked: {
                processLayer.visible = true
                mainLayer.visible = false
            }
        }

        // --- Кнопка "Назад" ---
        CustomButton {
            id: backButton
            width: parent.width/2.16
            height: parent.height/5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: startCompensationButton.bottom
            anchors.topMargin: parent.height/18
            buttonText: qsTr("Назад")
            onButtonClicked: {
                stackView.pop()
            }
        }
    }

    // --- Процесс компенсации ---
    Pane {
        id: processLayer
        anchors.fill: parent
        background: Rectangle {
            color: "transparent"
        }
        focusPolicy: Qt.ClickFocus
        visible: false
        CustomButton {
            id: cancelButton
            width: parent.width/3
            height: parent.height/6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/20
            buttonText: qsTr("Отмена")
            onButtonClicked: {
                processLayer.visible = false
                mainLayer.visible = true
            }
        }

        // --- Показания АЦП ---
        Text {
            id: adcTitle
            width: progressBar.width/2
            height: parent.height/15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height/12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height*0.65
            color: application.fontColor
            text: qsTr("Показания АЦП")
        }
        Text {
            id: adcValue
            width: adcTitle.width
            height: parent.height/15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: adcTitle.bottom
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            font.pixelSize: height*0.65
            color: application.fontColor
            text: qsTr("12345")
            Rectangle {
                height: 1
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }


        // --- Процедура ---
        Text {
            id: procedureInfo
            width: progressBar.width*1.2
            height: parent.height/15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: progressBar.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: height*0.65
            color: application.fontColor
            text: qsTr("Измерения на чувствительном диапазоне")
        }

        // --- Прогресс-бар  ---
        ProgressBarWithPercents {
            id: progressBar
            width: parent.width/2
            height: parent.height/15
            anchors.centerIn: parent
        }
    }

}
