#ifndef ENGINE_H
#define ENGINE_H

#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

class Engine
{
public:
    Engine();
    static QQmlApplicationEngine* This_engine;
};

class Password {
public:
    const QString& getCurrentPassword();
    static Password* instance() {
        if(!pThis) {
            pThis = new Password();
        }
        return pThis;
    }
    void setCurrentPassword(const QString& str);
private:
    Password();
    ~Password();
    static Password* pThis;
    QString currentPassword;
};

#endif // ENGINE_H
