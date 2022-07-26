QT += quick sql serialbus serialport

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        ../Source/abstract_measurement_measurement.cpp \
        ../Source/averageadc.cpp \
        ../Source/averagemodbus.cpp \
        ../Source/beta.cpp \
        ../Source/beta_chamber.cpp \
        ../Source/beta_verify.cpp \
        ../Source/betameasurement.cpp \
        ../Source/betameasurementsettings.cpp \
        ../Source/emulelectrometer.cpp \
        ../Source/engine.cpp \
        ../Source/iblock.cpp \
        ../Source/ichamber.cpp \
        ../Source/main.cpp \
        ../Source/mainwindow.cpp \
        ../Source/modbus_emulator.cpp \
        ../Source/rs232.cpp \
        ../Source/rs485.cpp \
        ../Source/usersettings.cpp \
        ../Source/vendorsettings.cpp \
        ../Source/volthex.cpp

RESOURCES += ../Resource/qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    ../Source/abstract_measurement_measurement.h \
    ../Source/averageadc.h \
    ../Source/averagemodbus.h \
    ../Source/beta.h \
    ../Source/beta_chamber.h \
    ../Source/beta_verify.h \
    ../Source/betameasurement.h \
    ../Source/betameasurementsettings.h \
    ../Source/emulelectrometer.h \
    ../Source/engine.h \
    ../Source/iblock.h \
    ../Source/ichamber.h \
    ../Source/main.h \
    ../Source/mainwindow.h \
    ../Source/modbus_emulator.h \
    ../Source/rs232.h \
    ../Source/rs485.h \
    ../Source/usersettings.h \
    ../Source/vendorsettings.h \
    ../Source/volthex.h
