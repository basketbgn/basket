import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    id: textInputWithTitle
    property alias title: titleText.text //Название
    property alias titleFontSize: titleText.font.pixelSize //Размер шрифта названия
    property alias inputFontSize: input.font.pixelSize //Размер шрифта поля ввода
    property alias inputValidator: input.validator //Валидатор поля ввода
    property alias inputText: input.text //Введенный текст
    property alias inputLength: input.maximumLength //Максимальное число символов в поле ввода
    property alias placeHolderText: input.placeholderText //Текст с подсказкой, отображаемый в пустом поле ввода
    property bool twoLines: false //если название длинное и занимает более одной строки, свойство нужно установить в True, в зависимости от чего будет пересчитана высота элемента

    Rectangle {
        id: titleRectangle
        width: parent.width
        height: twoLines ? parent.height*2/3 : parent.height/2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        color: "transparent"
        Text {
            id: titleText
            anchors.fill: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: twoLines ? parent.height*0.3 : parent.height*0.6
            color: application.fontColor
            fontSizeMode: twoLines ? Text.HorizontalFit : Text.FixedSize
            text: qsTr("Поле ввода")
        }
    }
    Rectangle {
        id: inputRectangle
        width: parent.width
        height: twoLines ? parent.height/3 : parent.height/2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: titleRectangle.bottom
        color: application.inputFieldColor
        border.width: 2
        border.color: "#eeeeee"
        TextField {
            id: input
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Bold
            font.pixelSize: parent.height/1.5
            //validator: RegExpValidator{regExp: /\d{8}/}
            //inputMethodHints: Qt.ImhDigitsOnly
            placeholderText: "поле ввода"
            background: Rectangle {
                color: "transparent"
            }
            color: application.fontColor
            text: qsTr("")
            onAccepted: {

            }
        }
    }
}
