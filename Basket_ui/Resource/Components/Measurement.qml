import QtQuick 2.0

Item {
    width: 1280
    height: 800

    // --- Свойства компонента "Измерение" ---
    property alias time: timeValue.seconds //Время измерения в секундах
    property alias deviceType: deviceType.type //Тип: камера или блок
    property alias deviceName: device.text //Название камеры или блока
    property alias nuclideInfoVisible: nuclide.visible //видимость поля информации о нуклиде (для БДГ)
    property alias nuclideName: nuclideName.text // имя нуклида
    property alias additionalInfoTitle: additionalInformationTitle.text
    property alias additionalInfo: additionalInformation.text //Дополнительная информация по измерению

    property string measuredValueType: qsTr("МПД") //Тип измеряемого значения
    property string measuredValueDimension: qsTr("Гр/с") //Размерность измеряемой величины
    property alias averageVal: averageValue.text //Среднее значение измеряемой величины

    property alias standardDeviation: standardDeviationStringValue.value //СКО
    property alias standardDeviationOfIntegralValue: integralDeviationStringValue.value //СКО интегральной величины
    property alias currentVal: currentValue.text //Текущее значение измеряемой величины

    property alias integralValueType: integralValueTitle.valueType //Тип интегральной величины
    property alias integralValueDimension: integralValueTitle.dimension //Размерность интегральной величины
    property alias integralVal: integralValue.text //Значение интегральной величины

    property bool measurementAutoMode: true //True - если выбран автоматический режим измерения, False - если выбран ручной режим

    signal signalStartButtonClicked(bool start) //Сигнал при нажатии кнопки "Старт" (кнопка "Старт" и "Стоп" - одна и та же, кнопка имеет свойство bool start, показывающее состояение кнопки)

    // --- Режим измерения ---
    Text {
        id: measurementModeTitle
        height: parent.height/20
        width: parent.width/5.5
        anchors.top: parent.top
        anchors.topMargin: parent.height/25
        anchors.left: parent.left
        anchors.leftMargin: parent.width/35
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: height*0.65
        color: application.fontColor
        text: qsTr("Режим измерения: ")
    }
    Text {
        id: measurementMode
        height: parent.height/20
        width: parent.width/12
        anchors.verticalCenter: measurementModeTitle.verticalCenter
        anchors.left: measurementModeTitle.right
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: height*0.65
        color: "#FFD600"
        text: measurementAutoMode ? qsTr("Авто") : qsTr("Ручной")
    }

    // --- Камера/Блок ---
    Text {
        id: deviceType
        property string type: qsTr("Камера")
        height: parent.height/20
        width: parent.width/12
        anchors.top: measurementModeTitle.bottom
        anchors.left: measurementModeTitle.left
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: height*0.65
        color: application.fontColor
        text: type + ": "
    }
    Text {
        id: device
        height: parent.height/20
        width: parent.width/8
        anchors.verticalCenter: deviceType.verticalCenter
        anchors.left: deviceType.right
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: height*0.65
        color: "#FFD600"
        text: qsTr("ИКБ1")
    }

    // --- Нуклид (для БДГ) ---
    Text {
        id: nuclide
        height: parent.height/20
        width: parent.width/12
        anchors.top: deviceType.bottom
        anchors.left: deviceType.left
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: height*0.65
        color: application.fontColor
        text: qsTr("Нуклид: ")
        visible: false
    }
    Text {
        id: nuclideName
        height: parent.height/20
        width: parent.width/8
        anchors.verticalCenter: nuclide.verticalCenter
        anchors.left: nuclide.right
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: height*0.65
        color: "#FFD600"
        text: qsTr("60Co")
        visible: nuclide.visible
    }

    // --- Время ---
    Rectangle {
        id: timeRectangle
        height: parent.height/16
        width: parent.width/5.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: measurementModeTitle.verticalCenter
        color: "transparent"
        Text {
            id: timeTitle
            height: parent.height//20
            width: parent.width/2//14
            anchors.verticalCenter: parent.verticalCenter//measurementModeTitle.verticalCenter
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.65
            color: application.fontColor
            text: qsTr("Время: ")
        }
        Text {
            id: timeValue
            property int seconds: 0
            height: parent.height//20
            width: parent.width/2//15
            anchors.verticalCenter: parent.verticalCenter//timeTitle.verticalCenter
            anchors.left: timeTitle.right
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.65
            color: "#1BCC00"
            text: seconds + qsTr(" с")
            fontSizeMode: Text.HorizontalFit
        }
    }

    Timer {
        id: measurementTimer
        property int secondsValue: 0
        interval: 1000; running: false; repeat: true
        onTriggered: {
            secondsValue = secondsValue + 1
            timeValue.seconds = secondsValue
        }
    }

    // --- Доп. информация ---
    Text {
        id: additionalInformationTitle
        height: additionalInformation.height
        width: additionalInformation.width*5
        anchors.verticalCenter: additionalInformation.verticalCenter
        anchors.right: additionalInformation.left
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: height*0.65
        color: application.fontColor
        fontSizeMode: Text.Fit
        text: qsTr("")
    }
    Text {
        id: additionalInformation
        height: measurementModeTitle.height
        width: parent.width/25
        anchors.verticalCenter: measurementModeTitle.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: parent.width/35
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: height*0.65
        color: "#FFD600"
        fontSizeMode: Text.Fit
        text: qsTr("")
    }

    // --- Среднее значение измеряемой величины ---
    Text {
        id: averageValueTitle
        width: parent.width/3
        height: parent.height/20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: nuclide.bottom
        anchors.topMargin: parent.height/40
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: height * 0.7
        color: application.fontColor
        text: qsTr("Средняя ") + measuredValueType + ", " + measuredValueDimension
    }

    Text {
        id: averageValue
        width: parent.width/3
        height: parent.height/8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: averageValueTitle.bottom
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: height * 0.75
        color: "#E6BF00"
        text: qsTr("11345.15220")
        Rectangle {
            height: 2
            width: parent.width*1.5
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#E6BF00"
        }
    }

    // --- СКО ---
    Rectangle {
        id: standardDeviationRectangle
        height: parent.height/18
        width: parent.width/5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: averageValue.bottom
        anchors.topMargin: parent.height/35
        color: "transparent"
        Text {
            id: standardDeviationTitle
            height: parent.height
            width: parent.width/3
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: height*0.65
            color: application.fontColor
            text: qsTr("СКО ")
        }
        Text {
            id: standardDeviationStringValue
            property string value: "00.000"
            height: parent.height
            width: 2 * parent.width/3
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: standardDeviationTitle.right
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.65
            color: "#1BCC00"
            text: value + "%"
        }
    }

    // --- Текущее значение измеряемой величины ---
    Text {
        id: currentValueTitle
        width: parent.width/4
        height: parent.height/20
        anchors.left: parent.left
        anchors.leftMargin: parent.width/8
        anchors.top: standardDeviationRectangle.bottom
        anchors.topMargin: parent.height/20
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: height * 0.7
        color: application.fontColor
        text: qsTr("Текущая ") + measuredValueType + ", " + measuredValueDimension
        visible: !measurementAutoMode
    }
    Text {
        id: currentValue
        width: parent.width/4
        height: parent.height/14
        anchors.horizontalCenter: currentValueTitle.horizontalCenter
        anchors.top: currentValueTitle.bottom
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: height * 0.7
        color: application.fontColor//"#E6BF00"
        text: qsTr("1234.5678")
        visible: currentValueTitle.visible
        Rectangle {
            height: 2
            width: parent.width*1
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: application.fontColor//"#E6BF00"
        }
    }

    // --- Интегральная величина ---
    Text {
        id: integralValueTitle
        property string valueType: qsTr("Поглощенная доза")
        property string dimension: qsTr("Гр")
        width: parent.width/4
        height: parent.height/20
        anchors.right: parent.right
        anchors.rightMargin: measurementAutoMode ? (parent.width/2 - parent.width/8) : parent.width/8
        anchors.top: standardDeviationRectangle.bottom
        anchors.topMargin: parent.height/20
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: height * 0.7
        color: application.fontColor
        text: valueType + ", " + dimension
    }
    Text {
        id: integralValue
        width: parent.width/4
        height: parent.height/14
        anchors.horizontalCenter: integralValueTitle.horizontalCenter
        anchors.top: integralValueTitle.bottom
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: height * 0.7
        color: application.fontColor//"#E6BF00"
        text: qsTr("1234.5678 ")
        Rectangle {
            height: 2
            width: parent.width*1
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: application.fontColor//"#E6BF00"
        }
    }

    // --- СКО ---
    Rectangle {
        id: integralDeviationRectangle
        height: parent.height/22
        width: parent.width/5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: integralValue.bottom
        anchors.topMargin: parent.height/80
        color: "transparent"
        visible: measurementAutoMode
        Text {
            id: integralDeviationTitle
            height: parent.height
            width: parent.width/3
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: height*0.65
            color: application.fontColor
            text: qsTr("СКО ")
        }
        Text {
            id: integralDeviationStringValue
            property string value: "00.000"
            height: parent.height
            width: 2 * parent.width/3
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: integralDeviationTitle.right
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.65
            color: "#1BCC00"
            text: value + "%"
        }
    }

    // --- Кнопка "Назад" ---
    CustomButton {
        id: backButton
        width: parent.width/5
        height: parent.height/6.5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height/25
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: parent.width/30
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
        width: parent.width/5
        height: parent.height/6.5
        anchors.verticalCenter: backButton.verticalCenter
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: parent.width/30
        buttonFontSizeCoef: 0.3
        buttonText: start ? qsTr("Старт") : qsTr("Стоп")
        onButtonClicked: {
            start = !start
            if(!start) {
                measurementTimer.secondsValue = 0
                measurementTimer.start()
            } else {
                measurementTimer.stop()
            }
            signalStartButtonClicked(start) //start == true - калибровка остановлена, start == false - калибровка начата

        }
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.75}
}
##^##*/
