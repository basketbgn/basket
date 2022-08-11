import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import "../Components"

Item {
    id: calibration
    width: 1280
    height: 800

    // --- Свойства ---

    property alias time: timeValue.seconds //Время калибровки в секундах
    property alias deviceType: typeOfDevice.type //Тип: камера или блок
    property alias device: nameOfDevice.text //Название камеры или блока
    property alias nuclideInfoVisible: nuclide.visible //видимость поля информации о нуклиде (для БДГ)
    property alias nuclideName: nuclideName.text // имя нуклида
    property alias additionalInfo: additionalInformation.text //Дополнительная информация по калибровке (например, сообщение "Без фильтра")
    property alias nameOfMeasuredValue: measuredValue.text

    property alias currentOrCountRateAndUnit: currentOrCountRateTitle.text //Измеряемый при калибровке параметр: ток или скорость счёта
    property alias currentOrCountRateValue: currentOrCountRate.text //Значение тока или скорости счёта

    property alias standardDeviationValue: standardDeviationStringValue.value //Значение СКО

    property alias measuredValueOf: inputField.whatIsMeasured //Название измеряемой величины, значение которой вводится в поле ввода (МАЭД, МПД и т.п.)
    property alias measuredValueDimensionModel: inputField.dimensionModel //Модель размерностей измеряемой величины, используемая в комбо боксе

    property alias sensivity: sensivityValue.text //Значение чувствительности
    property alias sensivityDimension: sensivityTitle.dimension //Размерность чувствительности

    signal signalWriteButtonClicked() //Сигнал при нажатии кнопки "Записать"
    signal signalStartButtonClicked(bool start) //Сигнал при нажатии кнопки "Старт" (кнопка "Старт" и "Стоп" - одна и та же, кнопка имеет свойство bool start, показывающее состояение кнопки)


    Pane { //просто слой
        background: Rectangle {
            color: "transparent"
        }
        anchors.fill: parent
        focusPolicy: Qt.ClickFocus //ловит фокус при нажатии вне полей ввода и кнопок

        // --- Блок/Камера ---
        Text {
            id: typeOfDevice
            property string type: qsTr("Блок")
            height: parent.height/20
            width: parent.width/10
            anchors.top: parent.top
            anchors.topMargin: parent.height/45
            anchors.left: parent.left
            anchors.leftMargin: parent.width/35
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.8
            color: application.fontColor
            text: type + ": "
        }
        Text {
            id: nameOfDevice
            height: parent.height/20
            width: parent.width/7
            anchors.verticalCenter: typeOfDevice.verticalCenter
            anchors.left: typeOfDevice.right
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.8
            color: "#FFD600"
            text: qsTr("БДГ")
        }

        // --- Нуклид (для БДГ) ---
        Text {
            id: nuclide
            height: parent.height/20
            width: parent.width/10
            anchors.top: typeOfDevice.bottom
            anchors.left: typeOfDevice.left
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.8
            color: application.fontColor
            text: qsTr("Нуклид: ")
            visible: true
        }
        Text {
            id: nuclideName
            height: parent.height/20
            width: parent.width/7
            anchors.verticalCenter: nuclide.verticalCenter
            anchors.left: nuclide.right
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.8
            color: "#FFD600"
            text: qsTr("60Co")
            visible: nuclide.visible
        }

        // --- Время ---
        Text {
            id: timeTitle
            height: parent.height/20
            width: parent.width/11
            anchors.verticalCenter: timeValue.verticalCenter
            anchors.right: timeValue.left
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: height*0.8
            color: application.fontColor
            text: qsTr("Время: ")
        }
        Text {
            id: timeValue
            property int seconds: 0
            height: parent.height/20
            width: parent.width/20
            anchors.verticalCenter: typeOfDevice.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width/35
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: height*0.8
            color: "#1BCC00"
            fontSizeMode: Text.HorizontalFit
            text: seconds + " " + qsTr("с")
        }

        Timer {
            id: calibrationTimer
            property int secondsValue: 0
            interval: 1000; running: false; repeat: true
            onTriggered: {
                secondsValue = secondsValue + 1
                timeValue.seconds = secondsValue
            }
        }

        // --- Измеряемая величина ---
        Text {
            id: measuredValue
            height: typeOfDevice.height
            width: parent.width/3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: typeOfDevice.top
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: height*0.8
            color: application.fontColor//"#FFD600"
            fontSizeMode: Text.Fit
            visible: false
            text: qsTr("")
        }

        // --- Доп. информация ---
        Text {
            id: additionalInformation
            height: typeOfDevice.height
            width: parent.width/4.5
            anchors.left: nuclide.left
            anchors.right: currentOrCountRate.left
            anchors.top: nuclide.bottom
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.65
            color: application.fontColor
            fontSizeMode: Text.Fit
            text: qsTr("")
        }

        Rectangle {
            id: frame
            width: currentOrCountRate.width*1.1
            anchors.top: additionalInformation.bottom
            anchors.topMargin: parent.height/40
            anchors.bottom: writeButton.bottom
            anchors.bottomMargin: -parent.height/35
            anchors.horizontalCenter: currentOrCountRate.horizontalCenter
            color: "transparent"
            border.color: "#000000"
            border.width: 2
        }

        // --- Ток/Скорость счёта ---
        Text {
            id: currentOrCountRateTitle
            width: currentOrCountRate.width
            height: parent.height/16
            anchors.horizontalCenter: currentOrCountRate.horizontalCenter
            anchors.bottom: currentOrCountRate.top
            anchors.bottomMargin: parent.height/55
            font.pixelSize: height*0.65
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            color: application.fontColor
            text: qsTr("Скорость счёта, имп/с")
        }
        Text {
            id: currentOrCountRate
            height: parent.height/12
            width: parent.width/3
            anchors.left: parent.left
            anchors.leftMargin: parent.width/20
            anchors.top: additionalInformation.bottom
            anchors.topMargin: parent.height/9//50
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: height*0.7
            color: "#E6BF00"
            text: qsTr("3.002280E-11")
        }
        Rectangle {
            id: currentOrCountRateUnderline
            width: currentOrCountRate.width
            height: 2
            anchors.horizontalCenter: currentOrCountRate.horizontalCenter
            anchors.top: currentOrCountRate.bottom
            color: "#E6BF00"//"#FF9982"
        }

        // --- СКО ---
        Text {
            id: standardDeviationTitle
            height: parent.height/18
            width: parent.width/20
            anchors.top: currentOrCountRate.bottom
            anchors.topMargin: parent.height/40
            anchors.left: currentOrCountRate.left
            anchors.leftMargin: parent.width/10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: height*0.65
            color: application.fontColor
            text: qsTr("СКО ")
        }
        Text {
            id: standardDeviationStringValue
            property string value: "0.000"
            height: parent.height/18
            width: parent.width/10
            anchors.verticalCenter: standardDeviationTitle.verticalCenter
            anchors.left: standardDeviationTitle.right
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.65
            color: "#1BCC00"
            text: value + "%"
        }

        // --- Ввод значения ---
        TextInputWithDimension {
            id: inputField
            property string whatIsMeasured: qsTr("МПД")
            width: parent.width/2//2.2
            height: parent.height/8//4.5
            changeHeightRatio: true
            anchors.right: parent.right
            anchors.rightMargin: parent.width/35
            anchors.top: frame.top
            anchors.topMargin: -parent.height/19
            inputFieldWidthCoef: 2.2
            titleFontSizeCoef: 0.65
            cbFontSizeCoef: 0.9
            inputFieldFontSizeCoef: 0.7
            alignBottom: true
            dimensionModel: [qsTr("Гр/с"), qsTr("...")]
            //inputValidator:
            title: qsTr("Значение ") + whatIsMeasured
        }

        // --- Свитч "Измерение фоновой скорости счёта" ---
        Text {
            id: backgroundCountRateTitle
            width: parent.width/2.6
            height: parent.height/16
            anchors.left: inputField.left
            anchors.top: inputField.bottom
            anchors.topMargin: parent.height/15
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.6
            color: application.fontColor
            text: qsTr("Измерение фоновой скорости счёта")
        }

        CustomSwitch {
            id: backgroundCountRateSwitch
            width: parent.width/18
            height: parent.height/20
            anchors.verticalCenter: backgroundCountRateTitle.verticalCenter
            anchors.right: inputField.right
            check: false
        }

        // --- Свитч "Считывание чувствительности из блока" ---
        Text {
            id: sensivityFromBlockTitle
            width: parent.width/2.6
            height: parent.height/16
            anchors.left: inputField.left
            anchors.top: backgroundCountRateTitle.bottom
            anchors.topMargin: parent.height/15
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.6
            color: application.fontColor
            text: qsTr("Считывание чувствительности\nиз блока")
        }

        CustomSwitch {
            id: sensivityFromBlockSwitch
            width: parent.width/18
            height: parent.height/20
            anchors.verticalCenter: sensivityFromBlockTitle.verticalCenter
            anchors.right: inputField.right
        }

        // --- Чувствительность из блока ---
        Text {
            id: blockSensivityTitle
            property string dimension: qsTr("размерность")
            width: parent.width/3.3
            height: parent.height/16
            anchors.left: inputField.left
            anchors.top: sensivityFromBlockTitle.bottom
            anchors.topMargin: parent.height/15
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.6
            color: application.fontColor
            text: qsTr("Чувствительность из блока,\n") + dimension
        }
        CustomButton {
            id: blockSensivityButton
            width: parent.width/8
            height: blockSensivityTitle.height*1.2
            anchors.right: parent.right
            anchors.rightMargin: parent.width/35
            anchors.verticalCenter: blockSensivityTitle.verticalCenter
            buttonFontSizeCoef: 0.58
            buttonText: qsTr("Считать")
            onButtonClicked: {

            }
        }

        // --- Фоновая скорость счёта ---
        Text {
            id: backgroundRate
            width: parent.width/3.3
            height: parent.height/16
            anchors.left: inputField.left
            anchors.top: blockSensivityTitle.bottom
            anchors.topMargin: parent.height/15
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.6
            color: application.fontColor
            text: qsTr("Фоновая скорость счёта\nимп/с")
        }
        CustomButton {
            id: backgroundRateButton
            width: parent.width/8
            height: backgroundRate.height*1.2
            anchors.right: parent.right
            anchors.rightMargin: parent.width/35
            anchors.verticalCenter: backgroundRate.verticalCenter
            buttonFontSizeCoef: 0.58
            buttonText: qsTr("Записать")
            onButtonClicked: {

            }
        }

        // --- Чувствительность ---
        Rectangle {
            id: sensivityRectangle
            height: parent.height/7
            width: currentOrCountRate.width
            anchors.horizontalCenter: currentOrCountRate.horizontalCenter
            anchors.top: standardDeviationTitle.bottom
            anchors.topMargin: parent.height/40
            color: "transparent"
            Text {
                id: sensivityTitle
                property string dimension: qsTr("разм")
                width: parent.width
                height: parent.height/2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: height*0.55
                fontSizeMode: Text.HorizontalFit
                color: application.fontColor
                text: "Чувствительность, " + dimension
            }
            Text {
                id: sensivityValue
                width: parent.width
                height: parent.height/2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: sensivityTitle.bottom
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: parent.height*0.4
                fontSizeMode: Text.HorizontalFit
                color: "#E6BF00"
                text: qsTr("4.0022558E+10")
                Rectangle {
                    width: parent.width
                    height: 2
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#E6BF00"//application.fontColor
                }
            }
        }

        // --- Кнопка "Записать"
        CustomButton {
            id: writeButton
            height: parent.height/10
            width: parent.width/6
            anchors.horizontalCenter: sensivityRectangle.horizontalCenter
            anchors.top: sensivityRectangle.bottom
            anchors.topMargin: parent.height/45
            buttonFontSizeCoef: 0.45
            buttonText: qsTr("Записать")
            onButtonClicked: {
                signalWriteButtonClicked()
            }
        }

        // --- Кнопка "Назад" ---
        CustomButton {
            id: backButton
            width: parent.width/6
            height: parent.height/6.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/25
            anchors.left: frame.left
            buttonFontSizeCoef: 0.3
            buttonText: qsTr("Назад")
            onButtonClicked: {
                stackView.pop()
            }
        }

        // --- Кнопка "Старт" ---
        CustomButton {
            id: startButton
            property bool start: true
            width: parent.width/6
            height: parent.height/6.5
            anchors.verticalCenter: backButton.verticalCenter
            anchors.right: frame.right
            buttonFontSizeCoef: 0.3
            buttonText: start ? qsTr("Старт") : qsTr("Стоп")
            onButtonClicked: {
                start = !start
                if(!start) {
                    calibrationTimer.secondsValue = 0
                    calibrationTimer.start()
                } else {
                    calibrationTimer.stop()
                }
                signalStartButtonClicked(start) //start == true - калибровка остановлена, start == false - калибровка начата

            }
        }
    }
}
