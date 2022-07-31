#ifndef VENDORSETTINGS_H
#define VENDORSETTINGS_H

#include "engine.h"
#include "usersettings.h"
#include "settings_electrometer.h"

#include <QObject>

class VendorSettings : public QObject
{
    Q_OBJECT
public:
    VendorSettings();
    ~VendorSettings();
public slots:
    void onBackButton();
    void onUserSettingsButton();
    void onSettingsElectrometerTest();
private:
    QQmlApplicationEngine* this_engine;
    UserSettings* userSettings;
    Settings_electrometer* settingsElectrometer;
};

#endif // VENDORSETTINGS_H
