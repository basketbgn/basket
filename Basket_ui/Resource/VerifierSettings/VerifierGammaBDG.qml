import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import Qt.labs.qmlmodels 1.0
import "../Components"

Item {
    id: verifierGammaBDG
    property bool mainLayerVisible: true //видимость главного слоя
    property bool inputLayerVisible: false //видимость полей ввода
    property bool sensivityLayerVisible: false //видимость полей ввода параметров чувствительности

    property bool editPressed: false //нажата кнопка редактирования камеры
    property bool addPressed: false //нажата кнорка добавления камеры

    function layersVisibility(layerIndex) {
        switch (layerIndex) {
        case 0:
            mainLayerVisible = true
            inputLayerVisible = false
            sensivityLayerVisible = false
            addPressed = false
            editPressed = false
            table.currentRow = -1
            break
        case 1:
            mainLayerVisible = false
            inputLayerVisible = true
            sensivityLayerVisible = false
            break
        case 2:
            mainLayerVisible = false
            inputLayerVisible = false
            sensivityLayerVisible = true
            break

        }
    }

    function addRowToTable(nuclideName, dateOfVerification) {
        bdgModel.append({"nuclide": nuclideName, "verificationDate": dateOfVerification})
    }

    // --- Статус-бар ---
    StatusBar {
        id: verifierGammaBDGStatusBar
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
            font.pixelSize: verifierGammaBDG.height/50
            font.bold: true
            color: "#eeeeee"
            text: verifierGammaBDG.editPressed ? (verifierGammaBDG.sensivityLayerVisible ? qsTr("Правка: параметры чувствительности") : qsTr("Правка")) : (verifierGammaBDG.addPressed ? (verifierGammaBDG.sensivityLayerVisible ? qsTr("Добавить: параметры чувствительности") : qsTr("Добавить")) : qsTr("Гамма излучение (БДГ)"))
        }
    }

    //--- Главный слой ---
    Rectangle {
        id: verifierGammaBDGMainLayer //layerIndex = 0
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: verifierGammaBDGStatusBar.bottom
        color: "transparent"
        visible: mainLayerVisible

        //--- Кнопка "Правка" ---
        Rectangle {
            id: editButton
            width: parent.width/2.5
            height: parent.height/4
            anchors.top: parent.top
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
                        verifierGammaBDG.layersVisibility(1)
                        verifierGammaBDG.editPressed = true
                        verifierGammaBDG.addPressed = false
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
                    verifierGammaBDG.layersVisibility(1)
                    verifierGammaBDG.editPressed = false
                    verifierGammaBDG.addPressed = true
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
                        bdgModel.remove(table.currentRow)
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
                model: bdgModel
                backgroundVisible: false
                ListModel {
                    id: bdgModel
                    ListElement {
                        nuclide: qsTr("137Cs")
                        verificationDate: qsTr("12.12.2022")
                    }
                    ListElement {
                        nuclide: qsTr("241Am")
                        verificationDate: qsTr("12.12.2022")
                    }
                    ListElement {
                        nuclide: qsTr("60Co")
                        verificationDate: qsTr("12.12.2022")
                    }
                }

                Component {
                    id:itemDelegateText
                    Text {
                        id: delegateText
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
                    id: nuclideColumn
                    role: "nuclide"
                    title: qsTr("Нуклид")
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
                    id: rowRectangle
                    property color rowColor: "#39434B"
                    color: rowColor
                    border.color: "#eeeeee"
                    height: (tableRectangle.height - tableRectangle.height/15)/bdgModel.count

                    Rectangle{
                        x: nuclideColumn.width
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
        id: verifierGammaBDGInputLayer //layerIndex = 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: verifierGammaBDGStatusBar.bottom
        color: "transparent"
        visible: verifierGammaBDG.inputLayerVisible

        //--- Поля ввода ---

        TextInputWithTitle {
            id: nuclideName
            width: parent.width/2.5//2.8
            height: 3*parent.height/16 //parent.height/5.5
            anchors.left: parent.left
            anchors.leftMargin: parent.width/20//10
            anchors.top: parent.top
            anchors.topMargin: parent.height/30
            inputLength: 10
            twoLines: true
            title: qsTr("Нуклид с выраженным\nмоноэнергетическим излучением")
        }

        TextInputWithTitle {
            id: volume
            width: parent.width/2.5
            height: parent.height/8
            anchors.left: nuclideName.left
            anchors.top: nuclideName.bottom
            anchors.topMargin: parent.height/35
            inputValidator: RegExpValidator{regExp: /\d{,4}[\.\,]{,1}\d{,4}/}
            title: qsTr("Объем, см\u00B3")
        }

        TextInputWithTitle {
            id: serialNumber
            width: nuclideName.width
            height: volume.height
            anchors.right: parent.right
            anchors.rightMargin: parent.width/20//10
            anchors.bottom: nuclideName.bottom
            inputValidator: RegExpValidator{regExp: /\d{8}/}
            title: qsTr("Заводской номер")
        }

        TextInputWithTitle {
            id: dateOfManufacture
            width: serialNumber.width
            height: serialNumber.height
            anchors.right: serialNumber.right
            anchors.top: volume.top
            inputValidator: RegExpValidator{regExp: /^\s*(3[01]|[12][0-9]|0[1-9])\.(1[012]|0[1-9])\.((?:20|21)\d{2})\s*$/}
            title: qsTr("Дата изготовления")
        }

        TextInputWithTitle {
            id: dateOfLastVerification
            width: nuclideName.width
            height: volume.height
            anchors.right: dateOfManufacture.right
            anchors.top: dateOfManufacture.bottom
            anchors.topMargin: parent.height/35
            inputValidator: RegExpValidator{regExp: /^\s*(3[01]|[12][0-9]|0[1-9])\.(1[012]|0[1-9])\.((?:20|21)\d{2})\s*$/}
            title: qsTr("Дата последней поверки")
        }

        // --- Кнопка "Параметры чувствительности" ---

        Rectangle {
            id: sensivityParametersButton
            width: nuclideName.width
            height: volume.height
            anchors.verticalCenter: dateOfLastVerification.verticalCenter
            anchors.verticalCenterOffset: dateOfLastVerification.height/4
            anchors.right: nuclideName.right
            border.width: 2
            border.color: sensivityParametersMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            Text {
                id: sensivityParametersText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.3
                fontSizeMode: Text.Fit
                color: application.fontColor
                text: qsTr("Параметры\nчувствительности")
            }
            MouseArea {
                id: sensivityParametersMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    verifierGammaBDG.layersVisibility(2)
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
            anchors.right: sensivityParametersButton.right
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
                    addRowToTable(nuclideName.inputText, dateOfLastVerification.inputText)
                    verifierGammaBDG.layersVisibility(0)
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
                    verifierGammaBDG.layersVisibility(0)
                }
            }
        }
    }

    //--- Слой с полями ввода параметров чувствительности---
    Rectangle {
        id: sensitivityParametersLayer //layerIndex = 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: verifierGammaBDGStatusBar.bottom
        color: "transparent"
        visible: verifierGammaBDG.sensivityLayerVisible

        //--- Поля ввода ---


        TextInputWithDimension {
            id: maed
            width: parent.width/2.3//2.4
            height: parent.height/5
            anchors.left: parent.left
            anchors.leftMargin: parent.width/20
            anchors.top: parent.top
            anchors.topMargin: parent.height/35
            title: qsTr("По мощности амбиентного\nэквивалента дозы")
            dimensionModel: [qsTr("(имп/с)/(мкЗв/ч)"), qsTr("(имп/с)/(Зв/с)")]
        }

        TextInputWithDimension {
            id: mned
            width: maed.width
            height: maed.height
            anchors.left: maed.left
            anchors.top: maed.bottom
            anchors.topMargin: parent.height/35
            title: qsTr("По мощности направленного\nэквивалента дозы")
            dimensionModel: [qsTr("(имп/с)/(мкЗв/ч)"), qsTr("(имп/с)/(Зв/с)")]
        }

        TextInputWithDimension {
            id: mied
            width: maed.width
            height: maed.height
            anchors.left: maed.left
            anchors.top: mned.bottom
            anchors.topMargin: parent.height/35
            title: qsTr("По мощности индивидуального\nэквивалента дозы")
            dimensionModel: [qsTr("(имп/с)/(мкЗв/ч)"), qsTr("(имп/с)/(Зв/с)")]
        }

        TextInputWithDimension {
            id: kerma
            width: maed.width
            height: maed.height
            anchors.right: parent.right
            anchors.rightMargin: parent.width/20
            anchors.top: maed.top
            title: qsTr("По КЕРМА в воздухе")
            dimensionModel: [qsTr("(имп/с)/(мкГр/ч)"), qsTr("(имп/с)/(Гр/с)")]
        }

        TextInputWithDimension {
            id: mpd
            width: maed.width
            height: maed.height
            anchors.right: kerma.right
            anchors.top: mned.top
            title: qsTr("По мощности\nпоглощенной дозы")
            dimensionModel: [qsTr("(имп/с)/(мкГр/ч)"), qsTr("(имп/с)/(Гр/с)")]
        }

        TextInputWithDimension {
            id: med
            width: maed.width
            height: maed.height
            anchors.right: mpd.right
            anchors.top: mied.top
            title: qsTr("По мощности\nэкспозиционной дозы")
            dimensionModel: [qsTr("(имп/с)/(мкР/ч)"), qsTr("(имп/с)/(Р/с)")]
        }

        // --- Кнопка "Назад" ---

        Rectangle {
            id: backToInputLayerButton
            width: okButton.width
            height: okButton.height
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/20
            anchors.horizontalCenter: parent.horizontalCenter
            border.width: 2
            border.color: backToInputLayerMouseArea.containsMouse ? "#0d9aff" : "#000000"
            radius: 5
            color: application.buttonColor
            Text {
                id: backToInputLayerText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: parent.height*0.3
                fontSizeMode: Text.Fit
                color: application.fontColor
                text: qsTr("Назад")
            }
            MouseArea {
                id: backToInputLayerMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    verifierGammaBDG.layersVisibility(1)
                }
            }
        }
    }
}
