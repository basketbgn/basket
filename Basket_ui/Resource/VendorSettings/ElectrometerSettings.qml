import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Item {
    id: electrometerSettings
    property bool limitValuesVisible: false

    Component.onCompleted: {
        _cppApi_ElectrometerSettings.init();
    }

    Connections {
        target: _cppApi_ElectrometerSettings
        function onSendInitValues(periodRS232,
                                  R1,
                                  referenceVoltage,
                                  heatingTime,
                                  changeTimeout,
                                  testTimeout,
                                  countsAver,
                                  minDAC,
                                  maxDAC,
                                  minRefVolt,
                                  maxRefVolt,
                                  minR2,
                                  maxR2,
                                  minR3,
                                  maxR3,
                                  minI,
                                  maxI) {
            pollingPeriodField.text =  periodRS232;
            r1ValueField.text = R1;
            referenceVoltageField.text = referenceVoltage;
            timeOfHeatingField.text = heatingTime;
            timeOutToModeField.text = changeTimeout;
            testTimeoutField.text = testTimeout;
            numberOfCountsField.text = countsAver;
            adcCodesMinField.text = minDAC;
            adcCodesMaxField.text = maxDAC;
            offsetVoltageMinField.text = minRefVolt;
            offsetVoltageMaxField.text = maxRefVolt;
            r2ValueMinField.text = minR2;
            r2ValueMaxField.text = maxR2;
            r3ValueMinField.text = minR3;
            r3ValueMaxField.text = maxR3;
            inputCurrentMinField.text = minI;
            inputCurrentMaxField.text = maxI;
        }
    }

    // --- Статус-бар ---
    StatusBar {
        id: electrometerSettingsStatusBar
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
            font.pixelSize: electrometerSettings.height/50
            font.bold: true
            color: "#eeeeee"
            text: qsTr("Настройки электрометра")
        }
    }

    // --- Поля ввода ---

    Rectangle {
        id: r1Value
        width: parent.width/2.5//2.8
        height: parent.height/7.2
        anchors.top: electrometerSettingsStatusBar.bottom
        anchors.topMargin: parent.height/35
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: parent.width/20
        color: "transparent"
        visible: !parent.limitValuesVisible
        Text {
            id: r1ValueText
            width: parent.width
            height: parent.height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: r1Value.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: parent.height*0.25
            color: application.fontColor
            text: qsTr("Величина R1, МОм")
        }
        Rectangle {
            id: r1ValueFieldRectangle
            width: parent.width
            height: parent.height/2
            anchors.top: parent.verticalCenter
            anchors.topMargin: parent.height/20
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: "#eeeeee"
            radius: 5
            color: application.inputFieldColor
            TextField {
                id: r1ValueField
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.Bold
                font.pixelSize: parent.height/1.5
                validator: RegExpValidator{regExp: /\d{8}/}
                inputMethodHints: Qt.ImhDigitsOnly
                color: application.fontColor
                background: Rectangle {
                    color: "transparent"
                }
                text: qsTr("")
                onTextChanged: _cppApi_ElectrometerSettings.onR1(text)
                onAccepted: {
                }
            }
        }
    }

    Rectangle {
        id: referenceVoltage
        width: parent.width/2.5//2.8
        height: parent.height/7.2
        anchors.top: r1Value.bottom
        anchors.topMargin: parent.height/35
        anchors.left: r1Value.left
        color: "transparent"
        visible: !parent.limitValuesVisible
        Text {
            id: referenceVoltageText
            width: parent.width
            height: parent.height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: referenceVoltage.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: parent.height*0.25
            color: application.fontColor
            text: qsTr("Опорное напряжение, мкВ")
        }
        Rectangle {
            id: referenceVoltageFieldRectangle
            width: parent.width
            height: parent.height/2
            anchors.top: parent.verticalCenter
            anchors.topMargin: parent.height/20
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: "#eeeeee"
            radius: 5
            color: application.inputFieldColor
            TextField {
                id: referenceVoltageField
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.Bold
                font.pixelSize: parent.height/1.5
                validator: RegExpValidator{regExp: /\d{8}/}
                inputMethodHints: Qt.ImhDigitsOnly
                color: application.fontColor
                background: Rectangle {
                    color: "transparent"
                }
                text: qsTr("")
                onTextChanged: _cppApi_ElectrometerSettings.onReferenceVoltage(text)
                onAccepted: {
                }
            }
        }
    }

    Rectangle {
        id: pollingPeriod
        width: parent.width/2.5//2.8
        height: parent.height/7.2
        anchors.top: electrometerSettingsStatusBar.bottom
        anchors.topMargin: parent.height/35
        anchors.left: r1Value.right
        anchors.leftMargin: parent.width/15
        color: "transparent"
        visible: !parent.limitValuesVisible
        Text {
            id: pollingPeriodText
            width: parent.width
            height: parent.height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: pollingPeriod.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: parent.height*0.25
            color: application.fontColor
            text: qsTr("Период опроса порта RS-232, с")
        }
        Rectangle {
            id: pollingPeriodFieldRectangle
            width: parent.width
            height: parent.height/2
            anchors.top: parent.verticalCenter
            anchors.topMargin: parent.height/20
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: "#eeeeee"
            radius: 5
            color: application.inputFieldColor
            TextField {
                id: pollingPeriodField
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.Bold
                font.pixelSize: parent.height/1.5
                validator: RegExpValidator{regExp: /\d{8}/}
                inputMethodHints: Qt.ImhDigitsOnly
                color: application.fontColor
                background: Rectangle {
                    color: "transparent"
                }
                text: qsTr("")
                onTextChanged: _cppApi_ElectrometerSettings.onPeriodRS232(text)
                onAccepted: {

                }
            }
        }
    }

    Rectangle {
        id: testTimeout
        width: parent.width/2.5//2.8
        height: parent.height/7.2
        anchors.top: pollingPeriod.bottom
        anchors.topMargin: parent.height/35
        anchors.left: referenceVoltage.right
        anchors.leftMargin: parent.width/15
        color: "transparent"
        visible: !parent.limitValuesVisible
        Text {
            id: testTimeoutText
            width: parent.width
            height: parent.height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: testTimeout.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: parent.height*0.25
            color: application.fontColor
            text: qsTr("Таймаут теста, с")
        }
        Rectangle {
            id: testTimeoutFieldRectangle
            width: parent.width
            height: parent.height/2
            anchors.top: parent.verticalCenter
            anchors.topMargin: parent.height/20
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: "#eeeeee"
            radius: 5
            color: application.inputFieldColor
            TextField {
                id: testTimeoutField
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
                font.weight: Font.Bold
                font.pixelSize: parent.height/1.5
                validator: RegExpValidator{regExp: /\d{8}/}
                inputMethodHints: Qt.ImhDigitsOnly
                color: application.fontColor
                background: Rectangle {
                    color: "transparent"
                }
                text: qsTr("")
                onTextChanged: _cppApi_ElectrometerSettings.onTestTimeout(text)
                onAccepted: {

                }
            }
        }
    }

    Rectangle {
        id: timeOfHeating
        width: parent.width/2.5//2.8
        height: parent.height/6
        anchors.top: referenceVoltage.bottom
        anchors.topMargin: parent.height/35
        anchors.left: r1Value.left
        color: "transparent"
        visible: !parent.limitValuesVisible
        Text {
            id: timeOfHeatingText
            width: parent.width
            height: parent.height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: timeOfHeating.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.2
            color: application.fontColor
            text: qsTr("Время прогрева аппаратуры\nпосле включения питания, с")
        }
        Rectangle {
            id: timeOfHeatingFieldRectangle
            width: parent.width
            height: parent.height/2.2
            anchors.top: parent.verticalCenter
            anchors.topMargin: parent.height/20
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: "#eeeeee"
            radius: 5
            color: application.inputFieldColor
            TextField {
                id: timeOfHeatingField
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.Bold
                font.pixelSize: parent.height/1.5
                validator: RegExpValidator{regExp: /\d{8}/}
                inputMethodHints: Qt.ImhDigitsOnly
                color: application.fontColor
                background: Rectangle {
                    color: "transparent"
                }
                text: qsTr("")
                onTextChanged: _cppApi_ElectrometerSettings.onHeatingTime(text)
                onAccepted: {

                }
            }
        }
    }

    Rectangle {
        id: timeOutToMode
        width: parent.width/2.5//2.8
        height: parent.height/6
        anchors.top: timeOfHeating.bottom
        anchors.topMargin: parent.height/35
        anchors.left: r1Value.left
        color: "transparent"
        visible: !parent.limitValuesVisible
        Text {
            id: timeOutToModeText
            width: parent.width
            height: parent.height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: timeOutToMode.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.2
            color: application.fontColor
            text: qsTr("Таймаут выхода на режим\nпосле изменения параметров, с")
        }
        Rectangle {
            id: timeOutToModeFieldRectangle
            width: parent.width
            height: parent.height/2.2
            anchors.top: parent.verticalCenter
            anchors.topMargin: parent.height/20
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: "#eeeeee"
            radius: 5
            color: application.inputFieldColor
            TextField {
                id: timeOutToModeField
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.Bold
                font.pixelSize: parent.height/1.5
                validator: RegExpValidator{regExp: /\d{8}/}
                inputMethodHints: Qt.ImhDigitsOnly
                color: application.fontColor
                background: Rectangle {
                    color: "transparent"
                }
                text: qsTr("")
                onTextChanged: _cppApi_ElectrometerSettings.onChangeTimeout(text)
                onAccepted: {

                }
            }
        }
    }

    Rectangle {
        id: numberOfCounts
        width: parent.width/2.5//2.8
        height: parent.height/6
        anchors.top: testTimeout.bottom
        anchors.topMargin: parent.height/35
        anchors.left: timeOfHeating.right
        anchors.leftMargin: parent.width/15
        color: "transparent"
        visible: !parent.limitValuesVisible
        Text {
            id: numberOfCountsText
            width: parent.width
            height: parent.height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: numberOfCounts.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignBottom
            font.pixelSize: parent.height*0.2
            color: application.fontColor
            text: qsTr("Количество\nотсчётов при усреднении")
        }
        Rectangle {
            id: numberOfCountsFieldRectangle
            width: parent.width
            height: parent.height/2.2
            anchors.top: parent.verticalCenter
            anchors.topMargin: parent.height/20
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: "#eeeeee"
            radius: 5
            color: application.inputFieldColor
            TextField {
                id: numberOfCountsField
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.Bold
                font.pixelSize: parent.height/1.5
                validator: RegExpValidator{regExp: /\d{8}/}
                inputMethodHints: Qt.ImhDigitsOnly
                color: application.fontColor
                background: Rectangle {
                    color: "transparent"
                }
                text: qsTr("")
                onTextChanged: _cppApi_ElectrometerSettings.onCountsAver(text)
                onAccepted: {

                }
            }
        }
    }

    //--- Кнопка "Предельные значения результатов теста" ---
    Rectangle {
        id: limitValuesButton
        width: r1Value.width
        height: timeOutToMode.height
        anchors.left: numberOfCounts.left
        anchors.verticalCenter: timeOutToMode.verticalCenter
        anchors.verticalCenterOffset: height/4
        border.width: 2
        border.color: limitValuesMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        visible: !parent.limitValuesVisible
        Text {
            id: limitValuesText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.25
            color: application.fontColor
            text: qsTr("Предельные значения\nрезультатов теста")
        }
        MouseArea {
            id: limitValuesMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                electrometerSettings.limitValuesVisible = true
            }
        }
    }

    // --- Поля ввода предельных значений ---

    Text {
        id: minText
        width: parent.width/4
        height: parent.height/15
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.horizontalCenterOffset: width/15
        anchors.top: electrometerSettingsStatusBar.bottom
        anchors.topMargin: parent.height/25
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height/25
        color: application.fontColor
        text: qsTr("Мин")
        visible: electrometerSettings.limitValuesVisible
    }

    Text {
        id: maxText
        width: parent.width/4
        height: parent.height/15
        anchors.left: minText.right
        anchors.leftMargin: width/4
        anchors.top: minText.top
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height/25
        color: application.fontColor
        text: qsTr("Макс")
        visible: electrometerSettings.limitValuesVisible
    }

    //--- ---
    Text {
        id: adcCodesText
        height: parent.height/15
        anchors.left: parent.left
        anchors.leftMargin: parent.width/20
        anchors.right: adcCodesMinRectangle.left
        anchors.top: adcCodesMinRectangle.top
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height/32
        color: application.fontColor
        text: qsTr("Значение кодов ЦАП")
        visible: electrometerSettings.limitValuesVisible
    }

    Rectangle {
        id: adcCodesMinRectangle
        width: minText.width
        height: minText.height
        anchors.top: minText.bottom
        anchors.left: minText.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: adcCodesMinField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMinDAC(text)
            onAccepted: {

            }
        }
    }

    Rectangle {
        id: adcCodesMaxRectangle
        width: maxText.width
        height: maxText.height
        anchors.top: maxText.bottom
        anchors.left: maxText.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: adcCodesMaxField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMaxDAC(text)
            onAccepted: {

            }
        }
    }

    //--- ---
    Text {
        id: offsetVoltageText
        height: parent.height/15
        anchors.left: parent.left
        anchors.leftMargin: parent.width/20
        anchors.right: offsetVoltageMinRectangle.left
        anchors.top: offsetVoltageMinRectangle.top
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height/32
        color: application.fontColor
        text: qsTr("Напряжение смещения, мкВ")
        visible: electrometerSettings.limitValuesVisible
    }

    Rectangle {
        id: offsetVoltageMinRectangle
        width: minText.width
        height: minText.height
        anchors.top: adcCodesMinRectangle.bottom
        anchors.topMargin: parent.height/14
        anchors.left: adcCodesMinRectangle.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: offsetVoltageMinField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMinRefVolt(text)
            onAccepted: {

            }
        }
    }

    Rectangle {
        id: offsetVoltageMaxRectangle
        width: maxText.width
        height: maxText.height
        anchors.top: adcCodesMaxRectangle.bottom
        anchors.topMargin: parent.height/14
        anchors.left: adcCodesMaxRectangle.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: offsetVoltageMaxField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMaxRefVolt(text)
            onAccepted: {

            }
        }
    }

    //--- ---
    Text {
        id: r2ValueText
        height: parent.height/15
        anchors.left: parent.left
        anchors.leftMargin: parent.width/20
        anchors.right: r2ValueMinRectangle.left
        anchors.top: r2ValueMinRectangle.top
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height/32
        color: application.fontColor
        text: qsTr("Величина R2, МОм")
        visible: electrometerSettings.limitValuesVisible
    }

    Rectangle {
        id: r2ValueMinRectangle
        width: minText.width
        height: minText.height
        anchors.top: offsetVoltageMinRectangle.bottom
        anchors.topMargin: parent.height/14
        anchors.left: offsetVoltageMinRectangle.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: r2ValueMinField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMinR2(text)
            onAccepted: {

            }
        }
    }

    Rectangle {
        id: r2ValueMaxRectangle
        width: maxText.width
        height: maxText.height
        anchors.top: offsetVoltageMaxRectangle.bottom
        anchors.topMargin: parent.height/14
        anchors.left: offsetVoltageMaxRectangle.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: r2ValueMaxField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMaxR2(text)
            onAccepted: {

            }
        }
    }

    //--- ---
    Text {
        id: r3ValueText
        height: parent.height/15
        anchors.left: parent.left
        anchors.leftMargin: parent.width/20
        anchors.right: r3ValueMinRectangle.left
        anchors.top: r3ValueMinRectangle.top
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height/32
        color: application.fontColor
        text: qsTr("Величина R3, ГОм")
        visible: electrometerSettings.limitValuesVisible
    }

    Rectangle {
        id: r3ValueMinRectangle
        width: minText.width
        height: minText.height
        anchors.top: r2ValueMinRectangle.bottom
        anchors.topMargin: parent.height/14
        anchors.left: r2ValueMinRectangle.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: r3ValueMinField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMinR3(text)
            onAccepted: {

            }
        }
    }

    Rectangle {
        id: r3ValueMaxRectangle
        width: maxText.width
        height: maxText.height
        anchors.top: r2ValueMaxRectangle.bottom
        anchors.topMargin: parent.height/14
        anchors.left: r2ValueMaxRectangle.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: r3ValueMaxField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMaxR3(text)
            onAccepted: {

            }
        }
    }

    //--- ---
    Text {
        id: inputCurrentText
        height: parent.height/15
        anchors.left: parent.left
        anchors.leftMargin: parent.width/20
        anchors.right: inputCurrentMinRectangle.left
        anchors.top: inputCurrentMinRectangle.top
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: parent.height/32
        color: application.fontColor
        text: qsTr("Входной ток, пА")
        visible: electrometerSettings.limitValuesVisible
    }

    Rectangle {
        id: inputCurrentMinRectangle
        width: minText.width
        height: minText.height
        anchors.top: r3ValueMinRectangle.bottom
        anchors.topMargin: parent.height/14
        anchors.left: r3ValueMinRectangle.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: inputCurrentMinField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMinI(text)
            onAccepted: {

            }
        }
    }

    Rectangle {
        id: inputCurrentMaxRectangle
        width: maxText.width
        height: maxText.height
        anchors.top: r3ValueMaxRectangle.bottom
        anchors.topMargin: parent.height/14
        anchors.left: r3ValueMaxRectangle.left
        border.width: 2
        border.color: "#eeeeee"
        radius: 5
        color: application.inputFieldColor
        visible: electrometerSettings.limitValuesVisible
        TextField {
            id: inputCurrentMaxField
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            validator: RegExpValidator{regExp: /\d{8}/}
            inputMethodHints: Qt.ImhDigitsOnly
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onTextChanged: _cppApi_ElectrometerSettings.onMaxI(text)
            onAccepted: {

            }
        }
    }

    //--- Кнопки "ОК" и "Назад" ---

    Rectangle {
        id: backButton
        width: r1Value.width/2.5
        height: r1Value.height
        anchors.top: timeOutToMode.bottom
        anchors.topMargin: parent.height/20
        anchors.left: r1Value.left
        border.width: 2
        border.color: backButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        visible: !parent.limitValuesVisible
        Text {
            id: backText
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: backImg.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.3
            font.bold: true
            color: application.fontColor
            text: qsTr("Назад")
        }
        Image {
            id: backImg
            height: parent.height/2.2
            width: parent.width/3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/10
            mirror: true
            source: "qrc:/images/back.png"
        }
        MouseArea {
            id: backButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                _cppApi_ElectrometerSettings.onBackButton()
                stackView.pop()
            }
        }
    }

    Rectangle {
        id: okButton
        width: backButton.width
        height: backButton.height
        anchors.top: backButton.top
        anchors.right: r1Value.right
        border.width: 2
        border.color: okButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        visible: !parent.limitValuesVisible
        Text {
            id: okText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.3
            font.bold: true
            color: application.fontColor
            text: qsTr("ОК")
        }
        MouseArea {
            id: okButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                _cppApi_ElectrometerSettings.onOkButton()
            }
        }
    }

    //--- Кнопка "Назад" из "предельных значений" ---

    Rectangle {
        id: backFromLimitValuesButton
        width: parent.width/5
        height: r1Value.height
        anchors.top: backButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        border.width: 2
        border.color: backFromLimitValuesButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
        radius: 5
        color: application.buttonColor
        visible: parent.limitValuesVisible
        Text {
            id: backFromLimitValuesText
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: backFromLimitValuesImg.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height*0.3
            font.bold: true
            color: application.fontColor
            text: qsTr("Назад")
        }
        Image {
            id: backFromLimitValuesImg
            height: parent.height/2.2
            width: parent.width/5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/10
            mirror: true
            source: "qrc:/images/back.png"
        }
        MouseArea {
            id: backFromLimitValuesButtonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                electrometerSettings.limitValuesVisible = false
            }
        }
    }
}
