import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "../Components/"

Item {
    id: betaMeasurementSettings

    property bool isOperator: false //тестовое свойство, для проверки появления/скрытия кнопки "Калибровка"

    // --- Статус-бар ---
    StatusBar {
        id: betaMeasurementSettingsStatusBar
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
            font.pixelSize: betaMeasurementSettings.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Подготовка к измерению")
        }
    }

    // --- Главный слой ---
    Pane {
        id: mainLayer
        anchors.fill: parent
        background: Rectangle {
            color: "transparent"
        }
        focusPolicy: Qt.ClickFocus
        visible: true

        // --- Тип пользователя и ФИО ---
        Text {
            id: userType
            width: parent.width/3
            height: parent.height/20
            anchors.top: parent.top
            anchors.topMargin: betaMeasurementSettingsStatusBar.height
            anchors.left: parent.left
            anchors.leftMargin: parent.width/35
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: height*0.65
            color: "#eeeeee"
            text: qsTr("Поверитель")
        }
        Text {
            id: userName
            width: parent.width/3
            height: parent.height/20
            anchors.top: parent.top
            anchors.topMargin: betaMeasurementSettingsStatusBar.height
            anchors.right: parent.right
            anchors.rightMargin: parent.width/35
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: height*0.65
            color: "#eeeeee"
            text: qsTr("Иванов Иван Иванович")
        }

        // --- Выбор камеры ---
        Text {
            id: chamberText
            width: cbRectangle.width
            height: cbRectangle.height
            anchors.top: userType.bottom
            anchors.topMargin: parent.height/40
            anchors.horizontalCenter: cbRectangle.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: application.fontColor
            font.pixelSize: height*0.6
            text: qsTr("Камера")
        }
        Rectangle {
            id: cbRectangle
            width: parent.width/2
            height: parent.height/16
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: chamberText.bottom
            anchors.topMargin: 0//parent.height/40
            color: "#313131"
            border.width: 2
            border.color: "#eeeeee"
            ComboBoxStyled {
                id: chamberComboBox
                anchors.fill: parent
                cbFontSizeCoef: 1//0.9
                cbModel: [qsTr("ИКБ1 Дата поверки: 12.12.2022"), qsTr("ИКБ2 Дата поверки: 12.12.2022")]
            }
        }

        // --- Кнопка "Параметры измерения ---
        CustomButton {
            id: measurementParametersButton
            width: parent.width/3.89
            height: parent.height/3
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: parent.width/25
            buttonFontSizeCoef: 0.15
            buttonText: qsTr("Параметры измерения")
            onButtonClicked: {
                measurementParameters.visible = true
                mainLayer.visible = false
            }
        }

        // --- Кнопка "Компенсация токов утечки с камерой" ---
        CustomButton {
            id: compensationButton
            width: parent.width/3.89
            height: parent.height/3
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: parent.width/25
            anchors.verticalCenter: parent.verticalCenter
            buttonFontSizeCoef: 0.15
            buttonText: qsTr("Компенсация токов утечки с камерой")
            onButtonClicked: {

            }
        }
        // --- Свитч "Учесть компенсацию" ---
        Rectangle {
            id: switchRectangle
            width: parent.width/3
            height: parent.height/20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cbRectangle.bottom
            anchors.topMargin: parent.height/30
            color: "transparent"
            Text {
                id: considerCompensationText
                width: parent.width/1.18
                height: parent.height
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: height*0.85
                color: application.fontColor
                text: qsTr("Учесть компенсацию")
            }
            Switch {
                id: control
                width: cbRectangle.width/10
                height: cbRectangle.height/1.8
                anchors.left: considerCompensationText.right
                anchors.leftMargin: parent.width/50
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                checked: true
                indicator: Rectangle {
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 20
                    color: control.checked ? "#17a81a" : "#f8f8f8"
                    border.color: indicatorMouseArea.containsMouse ? "#0d9aff" : "#2e3438"
                    border.width: 2
                    Rectangle {
                        x: control.checked ? parent.width - width : 0
                        width: parent.height
                        height: parent.height
                        radius: 20
                        color: control.down ? "#cccccc" : "#ffffff"
                        border.color: indicatorMouseArea.containsMouse ? "#0d9aff" : "#2e3438"//control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
                    }
                    MouseArea {
                        id: indicatorMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            control.checked = !control.checked
                        }
                    }
                }
            }
        }

        // --- Кнопка "Назад" ---
        CustomButton {
            id: backButton
            width: parent.width/3.89
            height: parent.height/5//6.25
            anchors.verticalCenter: calibrationButton.verticalCenter
            anchors.left: !isOperator ? parent.left : measurementParametersButton.left
            anchors.leftMargin: !isOperator ? parent.width/18 : 0
            buttonFontSizeCoef: 0.3
            buttonText: qsTr("Назад")
            onButtonClicked: {
                stackView.pop()
            }
        }

        // --- Кнопка "Калибровка" ---
        CustomButton {
            id: calibrationButton
            width: parent.width/3.89
            height: parent.height/5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: compensationButton.bottom
            anchors.topMargin: parent.height/15
            buttonFontSizeCoef: 0.3
            buttonText: qsTr("Калибровка")
            visible: !isOperator
            onButtonClicked: {
                stackView.push("qrc:/Beta/BetaCalibration.qml")
            }
        }

        // --- Кнопка "Измерение" ---
        CustomButton {
            id: measurementButton
            width: parent.width/3.89
            height: parent.height/5
            anchors.verticalCenter: calibrationButton.verticalCenter
            anchors.right: !isOperator ? parent.right : compensationButton.right
            anchors.rightMargin: !isOperator ? parent.width/18 : 0
            buttonFontSizeCoef: 0.3
            buttonText: qsTr("Измерение")
            onButtonClicked: {
                stackView.push("qrc:/Beta/BetaMeasurement.qml")
            }
        }
    }

    // --- Параметры измерения ---
    Pane {
        id: measurementParameters
        anchors.fill: parent
        anchors.topMargin: betaMeasurementSettingsStatusBar.height
        background: Rectangle {
            color: "transparent"
        }
        focusPolicy: Qt.ClickFocus
        visible: false

        // --- Столбец с комбо-боксами ---
        // --- *** ---
        // --- Диапазон ---
        ComboBoxWithTitle {
            id: range
            height: parent.height/16
            width: parent.width/2.7
            anchors.top: parent.top
            anchors.topMargin: parent.height/10
            anchors.left: parent.left
            anchors.leftMargin: parent.width/12
            titleFontSize: parent.height/29
            titleWidth: width*0.4
            titleHeight: height
            comboBoxWidth: width*0.6
            comboBoxHeight: height
            comboBoxFontSizeCoef: 0.85
            comboBoxModel: [qsTr("Чувствительный"), qsTr("Средний"), qsTr("Грубый"), qsTr("Экспериментально")]
            title: qsTr("Диапазон")
        }

        //--- Пороги ---
        ComboBoxWithTitle {
            id: thresholds
            height: parent.height/16
            width: parent.width/2.7
            anchors.top: range.bottom
            anchors.topMargin: parent.height/17.4
            anchors.left: range.left
            titleFontSize: parent.height/29
            titleWidth: width*0.4
            titleHeight: height
            comboBoxWidth: width*0.6
            comboBoxHeight: height
            comboBoxFontSizeCoef: 0.85
            comboBoxModel: [qsTr("По дозе"), qsTr("По времени, с")]
            title: qsTr("Пороги")
        }

        //--- Режим измерения ---
        ComboBoxWithTitle {
            id: measurementMode
            height: parent.height/16
            width: parent.width/2.7
            anchors.top: thresholds.bottom
            anchors.topMargin: parent.height/17.4
            //anchors.bottom: numberOFMeasurements.top
            anchors.left: thresholds.left
            titleFontSize: parent.height/29
            titleWidth: width * 0.65
            titleHeight: height
            comboBoxWidth: width * 0.35
            comboBoxHeight: height
            comboBoxFontSizeCoef: 0.85
            comboBoxModel: [qsTr("Ручной"), qsTr("Авто")]
            title: qsTr("Режим измерения")
        }

        //--- Размерность измеряемой величины ---
        ComboBoxWithTitle {
            id: dimension
            height: parent.height/16
            width: parent.width/2.7
            anchors.top: measurementMode.bottom
            anchors.topMargin: parent.height/17.4
            anchors.left: measurementMode.left
            titleFontSize: parent.height/29
            titleWidth: width * 0.65
            titleHeight: height*1.1
            comboBoxWidth: width * 0.35
            comboBoxHeight: height
            comboBoxFontSizeCoef: 0.85
            comboBoxModel: [qsTr("Гр/с"), qsTr("...")]
            title: qsTr("Размерность\nизмеряемой величины")
        }

        // --- Столбец с полями ввода ---
        // --- *** ---
        // --- Время одного измерения, с ---
        TextInputWithTitle {
            id: timeOfOneMeasurement
            width: parent.width/2.7
            height: parent.height/8
            anchors.right: parent.right
            anchors.rightMargin: parent.width/12
            anchors.top: range.top
            anchors.topMargin: -parent.height/45
            titleFontSize: parent.height/29
            inputValidator: RegExpValidator{regExp: /\d{8}/}
            title: qsTr("Время одного измерения, с")
        }

        // --- Количество измерений ---
        TextInputWithTitle {
            id: numberOFMeasurements
            width: parent.width/2.7
            height: parent.height/8
            anchors.right: timeOfOneMeasurement.right
            anchors.top: timeOfOneMeasurement.bottom
            anchors.topMargin: (correctionFactor.y - timeOfOneMeasurement.y - timeOfOneMeasurement.height)/2 - numberOFMeasurements.height/2//parent.height/25
            titleFontSize: parent.height/29
            inputValidator: RegExpValidator{regExp: /\d{8}/}
            title: qsTr("Количество измерений")
        }

        // --- Корректирующий коэффициент ---
        TextInputWithTitle {
            id: correctionFactor
            width: parent.width/2.7
            height: parent.height/8
            anchors.right: numberOFMeasurements.right
            //anchors.top: numberOFMeasurements.bottom
            //anchors.topMargin: parent.height/25
            anchors.bottom: dimension.bottom
            titleFontSize: parent.height/29
            inputValidator: RegExpValidator{regExp: /\d{,4}[\.\,]{,1}\d{,4}/}
            title: qsTr("Корректирующий коэффициент")
        }

        // --- Кнопка "Условия измерения" ---
        CustomButton {
            id: measurementConditionsButton
            width: parent.width/2.58
            height: parent.height/9.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: correctionFactor.bottom
            anchors.topMargin: parent.height/15
            buttonText: qsTr("Условия измерения")
            buttonFontSizeCoef: 0.4
            onButtonClicked: {
                measurementConditions.visible = true
                measurementParameters.visible = false
            }
        }

        // --- Кнопка "Назад" к главному слою---
        CustomButton {
            id: backToMainLayerButton
            width: parent.width/3.89
            height: parent.height/5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: measurementConditionsButton.bottom
            anchors.topMargin: parent.height/15
            buttonText: qsTr("Назад")
            buttonFontSizeCoef: 0.3
            onButtonClicked: {
                mainLayer.visible = true
                measurementParameters.visible = false
            }
        }
    }

    // --- Слой "Условия измерения" ---
    Pane {
        id: measurementConditions
        anchors.fill: parent
        anchors.topMargin: betaMeasurementSettingsStatusBar.height
        background: Rectangle {
            color: "transparent"
        }
        focusPolicy: Qt.ClickFocus
        visible: false
        // --- Поле "Температура, *С"
        TextInputWithTitle {
            id: temperature
            height: parent.height/8
            width: parent.width/2.7
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height/10
            inputValidator: RegExpValidator{regExp: /[\-]{,1}\d{,4}[\.\,]{,1}\d{,4}/}
            titleFontSize: parent.height/25
            title: qsTr("Температура, \u00B0C")
        }

        Image {
            id: temperatureImg
            height: parent.height/16
            width: height
            anchors.right: temperature.right
            anchors.top: temperature.top
            anchors.topMargin: -height/5
            source: "qrc:/images/temperature.png"
        }

        // --- Поле "Давление, мм.рт.ст."
        TextInputWithTitle {
            id: atmosphericPressureMercury
            height: parent.height/8
            width: parent.width/2.7
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: temperature.bottom
            anchors.topMargin: parent.height/12
            inputValidator: RegExpValidator{regExp: /\d{,4}[\.\,]{,1}\d{,4}/}
            titleFontSize: parent.height/25
            title: qsTr("Давление, мм.рт.ст.")
        }

        Image {
            id: pressureImg
            height: parent.height/16
            width: height
            anchors.right: atmosphericPressureMercury.right
            anchors.top: atmosphericPressureMercury.top
            anchors.topMargin: -height/5
            source: "qrc:/images/pressure.png"
        }

        Rectangle {
            id: atmosphericPressurePascalsRectangle
            height: parent.height/16
            width: parent.width/2.7
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: atmosphericPressureMercury.bottom
            anchors.topMargin: parent.height/12
            color: "transparent"
            Text {
                id: pressurePaTitle
                height: parent.height
                width: parent.width*0.6
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: parent.height*0.65
                color: application.fontColor
                text: qsTr("Давление, Па:")
            }
            Text {
                id: pressurePaValue
                height: parent.height - 1
                width: parent.width*0.4
                anchors.left: pressurePaTitle.right
                anchors.right: parent.right
                anchors.top: parent.top
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: parent.height*0.65
                color: application.fontColor
                text: qsTr("5")
            }
            Rectangle {
                id: underLine
                width: pressurePaValue.width
                height: 1
                color: application.fontColor
                anchors.horizontalCenter: pressurePaValue.horizontalCenter
                anchors.top: pressurePaValue.bottom
            }

        }

        // --- Кнопка "Назад" к главному слою---
        CustomButton {
            id: backToMeasurementParametersButton
            width: parent.width/3.89
            height: parent.height/5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/15
            buttonText: qsTr("Назад")
            buttonFontSizeCoef: 0.3
            onButtonClicked: {
                measurementParameters.visible = true
                measurementConditions.visible = false
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.1;height:800;width:1280}
}
##^##*/
