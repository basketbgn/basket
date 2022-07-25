#ifndef USERSETTINGS_H
#define USERSETTINGS_H

#include "engine.h"
#include <QObject>

#include <QDebug>

class UserSettings : public QObject
{
    Q_OBJECT
public:
    UserSettings();
    ~UserSettings();
signals:
    void setChecked(bool);
public slots:
    void init();
    void onBackButton();
    void onSendChecked(bool);
private:
    QQmlApplicationEngine* this_engine;
    bool IsEmulatorOrDetector = false;
};

#endif // USERSETTINGS_H
