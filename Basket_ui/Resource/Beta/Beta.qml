import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Components"
Item {
    id: beta
    //  --- fill textFields from database ---
    Component.onCompleted: {
        _cppApi_Beta.initDatabase();
    }
    // in Qml 5.15 there is a new syntax for connections
    Connections {
        target: _cppApi_Beta
        function onTransmitName(name) {
            betaWindow.name = name
            //nameField.text = name
        }
        function onTransmitSurname(surname) {
            betaWindow.surname = surname
            //surnameField.text = surname
        }
        function onTransmitSecondName(secondName) {
            betaWindow.secondName = secondName
            //secondNameField.text = secondName
        }
        function onSendTestPassed(state) {
            console.log("onSendTestPassed(state)", state)
            if(state) {
                betaWindow.isTestPassed = true
                //measurementButton.isTestPassed = true
                if(betaWindow.needTestPassed) {
                //if(measurementButton.needTestPassed) {
                    _cppApi_Beta.onMeasurementButton()
                    stackView.push("qrc:/Beta/BetaMeasurementSettings.qml")
                }
            } else {
                betaWindow.isTestPassed = false
                //measurementButton.isTestPassed = false
            }
        }
    }    
    //  old syntax
//    Connections {
//        target: _cppApi
//            onTransmitName: function(name){
//            surnameField.text = name
//        }
//    }

    //Вынес всё, что было в /Components/TransitionWindowToMeasurementAndTest.qml, так как используем одно и то же не один раз
    TransitionWindowToMeasurementAndTest {
        id: betaWindow
        windowTitle: qsTr("Бета излучение")
        anchors.fill: parent
        onNameWasChanged: {
            _cppApi_Beta.onNameChanged(text)
        }
        onSecondNameWasChanged: {
            _cppApi_Beta.onSecondNameChanged(text)
        }
        onSurnameWasChanged: {
            _cppApi_Beta.onSurnameChanged(text)
        }
        onHardwareTestButtonClicked: {
            needTestPassed = false;
            _cppApi_Beta.onHardwareTestButton()
            stackView.push("qrc:/Beta/BetaHardwareTest.qml")
        }
        onMeasurementButtonClicked: {
            if(isTestPassed) {
                _cppApi_Beta.onMeasurementButton()
                stackView.push("qrc:/Beta/BetaMeasurementSettings.qml")
            } else {
                needTestPassed = true;
                _cppApi_Beta.onHardwareTestButton()
                stackView.push("qrc:/Beta/BetaHardwareTest.qml")
            }
        }
        onBackButtonClicked: {
            _cppApi_Beta.onBackButton()
        }

    }

}
