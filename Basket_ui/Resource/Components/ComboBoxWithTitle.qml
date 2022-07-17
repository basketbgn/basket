import QtQuick 2.0

Item { //Комбо-бокс с названием

    property alias titleFontSize: titleText.font.pixelSize //Размер шрифта названия
    property alias title: titleText.text //Текст названия

    // ширина и высота названия и комбо-бокса настраиваются отдельно для более удобного позиционирования
    property alias titleWidth: titleText.width //Ширина названия
    property alias titleHeight: titleText.height //Высота названия
    property alias comboBoxWidth: comboBox.width //Ширина комбо-бокса
    property alias comboBoxHeight: comboBox.height //Высота комбо-бокса
    property alias comboBoxModel: comboBox.cbModel //Модель элементов комбо-бокса
    property alias comboBoxFontSizeCoef: comboBox.cbFontSizeCoef //Коэффициент, регулирующий размер шрифта комбо-бокса.

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
    ComboBoxStyled {
        id: comboBox
        height: parent.height
        width: parent.width/2
        anchors.verticalCenter: titleText.verticalCenter
        anchors.left: titleText.right
        backgroundColor: "#2E3438"
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.33;height:800;width:1280}
}
##^##*/
