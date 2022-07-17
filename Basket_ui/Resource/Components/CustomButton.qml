import QtQuick 2.0

Item {
    //Кнопка
    id: button
    property double buttonFontSizeCoef: 0.3 //коэффициент, регулирующий размер шрифта текста кнопки
    property alias buttonText: textButton.text //текст кнопки
    signal buttonClicked() //сигнал нажатия на кнопку

    Rectangle {
        id: buttonRectangle
        anchors.fill: parent
        color: application.buttonColor
        border.color: buttonMouseArea.containsMouse ? "#0d9aff" : "#000000" //цвет границ кнопки меняется при наведении на кнопку
        border.width: 2
        radius: 5
        Text {
            id: textButton
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: parent.height*buttonFontSizeCoef
            wrapMode: Text.WordWrap
            color: application.fontColor
            text: qsTr("Кнопка")
        }
        MouseArea {
            id: buttonMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                buttonClicked()
            }
        }
    }
}
