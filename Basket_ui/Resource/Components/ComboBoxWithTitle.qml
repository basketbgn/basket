import QtQuick 2.0
import QtQuick.Controls 2.0
Item { //Комбо-бокс с названием

    property alias titleFontSize: titleText.font.pixelSize //Размер шрифта названия
    property alias title: titleText.text //Текст названия

    // ширина и высота названия и комбо-бокса настраиваются отдельно для более удобного позиционирования
    property alias titleWidth: titleText.width //Ширина названия
    property alias titleHeight: titleText.height //Высота названия
    property alias comboBoxWidth: comboBox.width //Ширина комбо-бокса
    property alias comboBoxHeight: comboBox.height //Высота комбо-бокса
    property alias comboBoxModel: comboBox.cbModel //Модель элементов комбо-бокса
    property alias comboBoxText: comboBox.cbModelCurrentText //Модель элементов комбо-бокса
    property alias comboBoxFontSizeCoef: comboBox.cbFontSizeCoef //Коэффициент, регулирующий размер шрифта комбо-бокса.
    property alias comboBoxCurrentIndex: comboBox.currentIndex
    property alias valueInputVisible: valueRect.visible
    Text {
        id: titleText
        height: parent.height
        width: parent.width/2
        anchors.top: parent.top
        //anchors.topMargin: parent.height/25
        anchors.left: parent.left
        //anchors.leftMargin: parent.width/30
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 15
        color: application.fontColor
        wrapMode: Text.WordWrap
        text: qsTr("Название")
    }
    Rectangle {
        id: valueRect
        height: comboBox.height
        anchors.left: titleText.right
        anchors.right: comboBox.left
        anchors.rightMargin: parent.width/50
        anchors.bottom: comboBox.bottom
        anchors.bottomMargin: 0
        color: application.inputFieldColor
        border.width: 2
        border.color: "#eeeeee"
        visible: false
        TextField {
            id: valueInput
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //font.weight: Font.Bold
            font.pixelSize: parent.height/2
            validator: RegExpValidator{regExp: /\d{8}/}
            placeholderText: "значение"
            background: Rectangle {
                color: "transparent"
            }
            color: application.fontColor
            text: qsTr("")
            onAccepted: {

            }
        }
    }
    ComboBoxStyled {
        id: comboBox
        height: parent.height
        width: parent.width/2
        anchors.verticalCenter: titleText.verticalCenter
        anchors.right: parent.right
        backgroundColor: "#2E3438"
    }
}
