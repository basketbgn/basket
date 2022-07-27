import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
Item {
    id: textInputWithDimension
    property alias dimensionModel: dimensionCb.model //Модель размерностей
    property alias dimensionModelCurrentIndex: dimensionCb.currentIndex
    property alias title: titleText.text //Название поля ввода
    property alias inputValidator: textInput.validator //валидатор
    property double cbFontSizeCoef: 0.7 //Коэффициент, управляющий размером шрифта комбобокса размерности
    property double inputFieldWidthCoef: 1.8 //коэффициент, определяющий соотношение ширины поля ввода и комбобокса размерности
    property double inputFieldFontSizeCoef: 0.5 //Коэффициент размера шрифта в поле ввода
    property double titleFontSizeCoef: 0.3 //Коэффициент размера шрифта названия поля ввода
    property bool alignBottom: false //True - Название поля ввода привязано к низу, False - к центру по вертикали

    property bool changeHeightRatio: false //True - соотношение высоты названия и поля ввода: 1/2-1/2; False: 2/3 - 1/3

    width: 250
    height: 40
    Rectangle {
        id: title
        width: parent.width
        height: changeHeightRatio ? parent.height/2 : 2*parent.height/3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        color: "transparent"
        Text {
            id: titleText
            anchors.fill: parent
            anchors.bottomMargin: alignBottom ? parent.height/10 : 0
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: alignBottom ? Text.AlignBottom : Text.AlignVCenter
            font.pixelSize: parent.height * titleFontSizeCoef
            fontSizeMode: Text.Fit
            color: application.fontColor
            text: qsTr("Чувствительность")
        }
    }
    Rectangle {
        id: inputField
        width: title.width
        height: changeHeightRatio ? parent.height/2 : parent.height/3
        anchors.left: title.left
        anchors.top: title.bottom
        color: application.inputFieldColor
        border.width: 2
        border.color: "#eeeeee"
        TextField {
            id: textInput
            height: parent.height
            width: inputFieldWidthCoef * parent.width/3
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height * inputFieldFontSizeCoef
            validator: RegExpValidator{regExp: /\d{,10}[\.\,]{,1}\d{,4}/} //TODO e+10...
            inputMethodHints: Qt.ImhDigitsOnly
            placeholderText: "поле ввода"
            color: application.fontColor
            background: Rectangle {
                color: "transparent"
            }
            text: qsTr("")
            onAccepted: {

            }
            onTextChanged: {
                sendText(textInput.text)
            }
        }
        Rectangle {
            id: dimensionRect
            height: parent.height
            anchors.right: parent.right
            anchors.left: textInput.right
            border.width: 2
            border.color: "#eeeeee"
            color: "transparent"
            ComboBox {
                id: dimensionCb
                font.pixelSize: parent.height * cbFontSizeCoef//0.5
                anchors.fill: parent
                currentIndex: 0
                model: [/*qsTr("мГр/нКл"), qsTr("Гр/Кл")*/]
                background: Rectangle {
                    color: application.buttonColor
                    border.width: 2
                    border.color: "#eeeeee"
                }
                layer.mipmap: false
                layer.format: ShaderEffectSource.RGB
                onActivated:  {
                    sendCurrentIndex(dimensionCb.currentIndex)
                }                
                contentItem: Text {
                    anchors.right: dimensionCb.indicator.left
                    anchors.rightMargin: dimensionCb.width/40
                    anchors.left: dimensionCb.left
                    anchors.leftMargin: dimensionCb.width/25
                    text: dimensionCb.displayText
                    //font: dimensionCb.font
                    font.pixelSize: dimensionCb.font.pixelSize*0.6
                    color: application.fontColor
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    fontSizeMode: Text.HorizontalFit
                }

                delegate: ItemDelegate {
                    id: delegate
                    width: dimensionCb.width
                    contentItem: Text {
                     text: modelData
                     color: highlighted ? "#0d9aff" : application.fontColor
                     //font: dimensionCb.font
                     font.pixelSize: (dimensionCb.font.pixelSize)/2
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
                    anchors.rightMargin: dimensionCb.width/15
                    width: dimensionRect.width/10
                    height: dimensionRect.height/5
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
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.75}
}
##^##*/
