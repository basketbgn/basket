import QtQuick 2.0
import QtQuick.Controls 2.5

ApplicationWindow {
    id: application

    property color fontColor: "#f8f8f8" //Цвет шрифта
    property color buttonColor: "#2e3438" //Цвет кнопок
    property color inputFieldColor: "#48525a" //Цвет полей ввода

    width: 1280
    height: 800
    visible: true
    //title: qsTr("Basket")
    //flags: Qt.Window | Qt.FramelessWindowHint
    background: Rectangle {
        color: "#39434B"
    }
    StackView {
        id: stackView
        initialItem: "MainPage.qml"
        anchors.fill: parent
    }
}
