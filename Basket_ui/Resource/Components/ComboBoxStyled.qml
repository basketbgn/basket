import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Item {
    // Комбо-бокс со стилем
    id: comboBoxStyled
    property alias cbModel: cb.model //Модель, которая используется для заполнения Комбо-бокса
    property alias cbModelCurrentText: cb.displayText //Модель, которая используется для заполнения Комбо-бокса
    property double cbFontSizeCoef: 0.7 //Коэффициент, регулирующий размер шрифта, относительно высоты элемента
    property color backgroundColor: "transparent" //цвет фона комбо-бокса

    Rectangle {
        id: cbRect
        anchors.fill: parent
        border.width: 2
        border.color: "#eeeeee"
        color: "transparent"
        ComboBox {
            id: cb
            font.pixelSize: parent.height * cbFontSizeCoef//0.5
            anchors.fill: parent
            model: [qsTr("Element 1"), qsTr("Element 2")]
            background: Rectangle {
                color: backgroundColor
                border.width: 2
                border.color: "#eeeeee"
            }
            layer.mipmap: false
            layer.format: ShaderEffectSource.RGB
            onActivated:  {

            }
            contentItem: Text {
                anchors.right: cb.indicator.left
                anchors.rightMargin: cb.width/40
                anchors.left: cb.left
                anchors.leftMargin: cb.width/25
                text: cb.displayText
                //font: cb.font
                font.pixelSize: cb.font.pixelSize*0.6
                color: "#eeeeee"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                fontSizeMode: Text.HorizontalFit
            }

            delegate: ItemDelegate {
                id: delegate
                width: cb.width
                contentItem: Text {
                 text: modelData
                 color: highlighted ? "#0d9aff" : "#eeeeee"
                 //font: cb.font
                 font.pixelSize: cb.font.pixelSize * 0.6
                 elide: Text.ElideRight
                 verticalAlignment: Text.AlignVCenter
                 horizontalAlignment: Text.AlignHCenter
                }
                background: Rectangle {
                 color: delegate.pressed? "#e0e0e0" : "#2E3438"
                 border.color: "#000000"
                }
                highlighted: cb.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvas1
                anchors.verticalCenter: cb.verticalCenter
                anchors.right: cb.right
                anchors.rightMargin: cb.width/15
                width: height*1.1
                height: cbRect.height/2
                contextType: "2d"
                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = "#eeeeee"
                    context.fill();
                }
            }
        }
    }
}
