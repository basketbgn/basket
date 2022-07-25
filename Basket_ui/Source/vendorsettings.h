#ifndef VENDORSETTINGS_H
#define VENDORSETTINGS_H

#include "engine.h"
#include "usersettings.h"

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
private:
    QQmlApplicationEngine* this_engine;
    UserSettings* userSettings;
};

#endif // VENDORSETTINGS_H
