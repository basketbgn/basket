import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import Qt.labs.qmlmodels 1.0
import "../Components"

Item {
    id: verifierBetaIK
    property bool mainLayerVisible: true
    property bool editPressed: false
    property bool addPressed: false

    function addRowToTable(chamberName, dateOfVerification) {
        //WARNING: Model size of -1 is less than 0
        chambersModel.append({"chamber": chamberName, "verificationDate": dateOfVerification})
    }

    // --- Статус-бар ---
    StatusBar {
        id: verifierBetaIKStatusBar
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
            font.pixelSize: verifierBetaIK.height/50
            font.bold: true
            color: "#eeeeee"
            text: verifierBetaIK.editPressed ? qsTr("Правка") : (verifierBetaIK.addPressed ? qsTr("Добавить") : qsTr("Бета излучение (ИК)"))
        }
    }

    //--- Главный слой ---
    Rectangle {
        id: verifierBetaIKMainLayer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: verifierBetaIKStatusBar.bottom
        color: "transparent"
        visible: mainLayerVisible

        //--- Кнопка "Правка" ---
        Rectangle {
            id: editButton
            width: parent.width/2.5
            height: parent.height/4
            anchors.top: parent.top//verifierBetaIKStatusBar.bottom
            anchors.topMargin: parent.height/20
            anchors.left: parent.left
            anchors.leftMargin: parent.width/20
            border.width: 2
            border.color: editButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            Image {
                id: editImg
                height: width
                width: parent.width/7
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: editText.bottom
                anchors.topMargin: parent.height/10
                source: "qrc:/images/edit.png"
            }
            Text {
                id: editText
                width: parent.width
                height: parent.height/2.5
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.25
                color: application.fontColor
                text: qsTr("Правка")
            }
            MouseArea {
                id: editButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if(table.currentRow !== -1) {
                        verifierBetaIK.mainLayerVisible = false
                        verifierBetaIK.editPressed = true
                        verifierBetaIK.addPressed = false
                    }
                }
            }
        }

        //--- Кнопка "Добавить" ---
        Rectangle {
            id: addButton
            width: editButton.width/2.2
            height: editButton.height
            anchors.top: editButton.bottom
            anchors.topMargin: parent.height/25
            anchors.left: editButton.left
            border.width: 2
            border.color: addButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            Image {
                id: addImg
                height: width
                width: parent.width/3
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: addText.bottom
                source: "qrc:/images/add.png"
            }
            Text {
                id: addText
                width: parent.width
                height: parent.height/2.5
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.2
                color: application.fontColor
                text: qsTr("Добавить")
            }
            MouseArea {
                id: addButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    verifierBetaIK.mainLayerVisible = false
                    verifierBetaIK.addPressed = true
                    verifierBetaIK.editPressed = false
                }
            }
        }

        //--- Кнопка "Удалить" ---
        Rectangle {
            id: deleteButton
            width: addButton.width
            height: addButton.height
            anchors.top: addButton.top
            anchors.right: editButton.right
            border.width: 2
            border.color: deleteButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            Image {
                id: deleteImg
                height: width
                width: parent.width/3
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: deleteText.bottom
                source: "qrc:/images/delete.png"
            }
            Text {
                id: deleteText
                width: parent.width
                height: parent.height/2.5
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.2
                color: application.fontColor
                text: qsTr("Удалить")
            }
            MouseArea {
                id: deleteButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if(table.currentRow !== -1) {
                        chambersModel.remove(table.currentRow)
                        if((table.currentRow === (table.rowCount - 1)) || (table.currentRow === 0)) {
                            table.currentRow = -1
                        }
                    }
                }
            }
        }

        //--- Кнопка "Назад" ---
        Rectangle {
            id: backButton
            width: parent.width/2.5
            height: parent.height/4
            anchors.top: addButton.bottom
            anchors.topMargin: parent.height/25
            anchors.horizontalCenter: editButton.horizontalCenter
            border.width: 2
            border.color: backButtonMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            Image {
                id: backImg
                height: width
                width: parent.width/5
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: backText.bottom
                mirror: true
                source: "qrc:/images/back.png"
            }
            Text {
                id: backText
                width: parent.width
                height: parent.height/2.5
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.25
                color: application.fontColor
                text: qsTr("Назад")
            }
            MouseArea {
                id: backButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    stackView.pop()
                }
            }
        }

        //--- Таблица камер ---

        Rectangle {
            id: tableRectangle
            anchors.left: parent.horizontalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width/25
            anchors.top: editButton.top
            anchors.bottom: backButton.verticalCenter
            color: "transparent"

            TableView {
                id: table
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                model: chambersModel
                backgroundVisible: false
                ListModel {
                    id: chambersModel
                    ListElement {
                        chamber: qsTr("ИКБ1")
                        verificationDate: qsTr("12.12.2022")
                    }
                    ListElement {
                        chamber: qsTr("ИКБ2")
                        verificationDate: qsTr("12.12.2022")
                    }
                    ListElement {
                        chamber: qsTr("ИКБ7")
                        verificationDate: qsTr("12.12.2022")
                    }
                }

                Component{
                    id:itemDelegateText
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        color: (styleData.selected && table.currentRow !== -1) ? "#0d9aff" : application.fontColor
                        elide: styleData.elideMode
                        text: styleData.value
                        font.pixelSize: table.rowCount > 2 ? parent.height/5 : ((table.rowCount > 1) ? parent.height/7 : parent.height/15)
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                    }
                }

                TableViewColumn{
                    id: chamberColumn
                    role: "chamber"
                    title: qsTr("Камера")
                    width: table.width/2
                    delegate: itemDelegateText
                }

                TableViewColumn{
                    role: "verificationDate"
                    title: qsTr("Дата поверки")
                    width: table.width/2
                    delegate: itemDelegateText
                }

                headerDelegate: Rectangle{
                    id: hdelegate
                    height: tableRectangle.height/10
                    border.width: 1
                    color: application.buttonColor
                    border.color: "#eeeeee"
                    Text {
                        id: headerName
                        text: styleData.value
                        font.pixelSize: parent.height*0.5
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                        color: application.fontColor
                    }
                }

                rowDelegate: Rectangle {
                    id:rowRectangle
                    property color rowColor: "#39434B"
                    color: rowColor
                    border.color: "#eeeeee"
                    height: (tableRectangle.height - tableRectangle.height/15)/chambersModel.count

                    Rectangle{
                        x: chamberColumn.width
                        height: parent.height
                        width: 1
                        color: "#eeeeee"
                    }
               }
            }
        }
    }

    //--- Слой с полями ввода ---
    Rectangle {
        id: verifierBetaIKInputLayer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: verifierBetaIKStatusBar.bottom
        color: "transparent"
        visible: !mainLayerVisible

        //--- Поля ввода ---

        TextInputWithTitle {
            id: chamberName
            width: parent.width/2.3
            height: parent.height/8
            anchors.left: parent.left
            anchors.leftMargin: parent.width/20
            anchors.top: parent.top
            anchors.topMargin: parent.height/30
            inputLength: 10
            title: qsTr("Название камеры")
            placeHolderText: "поле ввода"
        }

        TextInputWithTitle {
            id: electrodeDiameter
            width: chamberName.width
            height: chamberName.height
            anchors.left: chamberName.left
            anchors.top: chamberName.bottom
            anchors.topMargin: parent.height/35
            inputValidator: RegExpValidator{regExp: /\d{,4}[\.\,]{,1}\d{,4}/}
            title: qsTr("Диаметр электрода, мм")
        }

        TextInputWithTitle {
            id: interElectrodeDistance
            width: electrodeDiameter.width
            height: electrodeDiameter.height
            anchors.left: electrodeDiameter.left
            anchors.top: electrodeDiameter.bottom
            anchors.topMargin: parent.height/35
            inputValidator: RegExpValidator{regExp: /\d{,4}[\.\,]{,1}\d{,4}/}
            title: qsTr("Межэлектродное расстояние, мм")
        }

        TextInputWithTitle {
            id: voltage
            width: chamberName.width
            height: chamberName.height
            anchors.right: parent.right
            anchors.rightMargin: parent.width/20
            anchors.top: chamberName.top
            inputValidator: RegExpValidator{regExp: /\d{,4}[\.\,]{,1}\d{,4}/}
            title: qsTr("Напряжение, В")
        }

        TextInputWithTitle {
            id: serialNumber
            width: voltage.width
            height: voltage.height
            anchors.right: voltage.right
            anchors.top: electrodeDiameter.top
            inputValidator: RegExpValidator{regExp: /\d{8}/}
            title: qsTr("Заводской номер")
        }

        TextInputWithTitle {
            id: dateOfManufacture
            width: serialNumber.width
            height: serialNumber.height
            anchors.right: serialNumber.right
            anchors.top: serialNumber.bottom
            anchors.topMargin: parent.height/35
            inputValidator: RegExpValidator{regExp: /^\s*(3[01]|[12][0-9]|0[1-9])\.(1[012]|0[1-9])\.((?:20|21)\d{2})\s*$/}
            title: qsTr("Дата изготовления")
        }

        TextInputWithTitle {
            id: dateOfLastVerification
            width: dateOfManufacture.width
            height: dateOfManufacture.height
            anchors.right: dateOfManufacture.right
            anchors.top: dateOfManufacture.bottom
            anchors.topMargin: parent.height/35
            inputValidator: RegExpValidator{regExp: /^\s*(3[01]|[12][0-9]|0[1-9])\.(1[012]|0[1-9])\.((?:20|21)\d{2})\s*$/}
            title: qsTr("Дата последней поверки")
        }

        Rectangle {
            id: sensitivity
            width: interElectrodeDistance.width
            height: interElectrodeDistance.height/2
            anchors.left: interElectrodeDistance.left
            anchors.top: interElectrodeDistance.bottom
            anchors.topMargin: parent.height/35
            color: "transparent"
            Text {
                id: sensitivityText
                anchors.fill: parent
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.6
                color: application.fontColor
                text: qsTr("Чувствительность")
            }
        }
        Rectangle {
            id: sensitivityField
            width: sensitivity.width
            height: sensitivity.height
            anchors.left: sensitivity.left
            anchors.top: sensitivity.bottom
            color: application.inputFieldColor
            border.width: 2
            border.color: "#eeeeee"
            TextField {
                id: sensitivityInput
                height: parent.height
                width: 2*parent.width/3
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.Bold
                font.pixelSize: parent.height/2
                validator: RegExpValidator{regExp: /\d{,8}[\.\,]{,1}\d{,5}e?[+-]?\d{2}e?[+-]?\d{2}/} //TODO e+10...
                inputMethodHints: Qt.ImhDigitsOnly
                placeholderText: "поле ввода"
                color: application.fontColor
                background: Rectangle {
                    color: "transparent"
                }

                text: qsTr("")
                onAccepted: {

                }
            }
            Rectangle {
                id: dimensionRect
                height: parent.height
                anchors.right: parent.right
                anchors.left: sensitivityInput.right
                border.width: 2
                border.color: "#eeeeee"
                color: "transparent"
                ComboBox {
                    id: dimensionCb
                    font.pixelSize: parent.height*0.5
                    anchors.fill: parent
                    model: [qsTr("мГр/нКл"), qsTr("Гр/Кл")]
                    background: Rectangle {
                        color:  application.buttonColor
                        border.width: 2
                        border.color: "#eeeeee"
                    }
                    layer.mipmap: false
                    layer.format: ShaderEffectSource.RGB
                    onActivated:  {

                    }
                    contentItem: Text {
                        text: dimensionCb.displayText
                        font: dimensionCb.font
                        color: application.fontColor
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }

                    delegate: ItemDelegate {
                        id: delegate
                        width: dimensionCb.width
                        contentItem: Text {
                            text: modelData
                            color: highlighted ? "#0d9aff" : application.fontColor
                            font: dimensionCb.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                        background: Rectangle {
                            color: delegate.pressed? "#e0e0e0" : application.buttonColor
                            border.color: "#000000"
                        }
                        highlighted: dimensionCb.highlightedIndex === index
                    }

                    indicator: Canvas {
                        id: canvas1
                        anchors.verticalCenter: dimensionCb.verticalCenter
                        anchors.right: dimensionCb.right
                        anchors.rightMargin: dimensionCb.width/10
                        width: dimensionRect.width/8
                        height: dimensionRect.height/3
                        contextType: "2d"
                        onPaint: {
                            context.reset();
                            context.moveTo(0, 0);
                            context.lineTo(width, 0);
                            context.lineTo(width / 2, height);
                            context.closePath();
                            context.fillStyle = application.fontColor
                            context.fill();
                        }
                    }
                }
            }
        }

        // --- Кнопка "ОК" ---

        Rectangle {
            id: okButton
            width: parent.width/6
            height: parent.height/5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/20
            anchors.right: sensitivity.right
            border.width: 2
            border.color: okMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            Text {
                id: okText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.3
                fontSizeMode: Text.Fit
                color: application.fontColor
                text: qsTr("ОК")
            }
            MouseArea {
                id: okMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    addRowToTable(chamberName.inputText, dateOfLastVerification.inputText)
                    verifierBetaIK.mainLayerVisible = true
                    verifierBetaIK.addPressed = false
                    verifierBetaIK.editPressed = false
                }
            }
        }

        // --- Кнопка "Отмена" ---

        Rectangle {
            id: backToMainLayerButton
            width: okButton.width
            height: okButton.height
            anchors.top: okButton.top
            anchors.left: dateOfLastVerification.left
            //anchors.leftMargin: parent.width/45
            border.width: 2
            border.color: backToMainLayerMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            Text {
                id: backToMainLayerText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.3
                fontSizeMode: Text.Fit
                color: application.fontColor
                text: qsTr("Отмена")
            }
            MouseArea {
                id: backToMainLayerMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    verifierBetaIK.mainLayerVisible = true
                    verifierBetaIK.addPressed = false
                    verifierBetaIK.editPressed = false
                }
            }
        }
    }
    //
}
