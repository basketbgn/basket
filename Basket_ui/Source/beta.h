#ifndef BETA_H
#define BETA_H

#include "engine.h"
#include "betameasurementsettings.h"

#include <QObject>
#include <QSqlDatabase> //подключаем класс настроек для работы с БД
#include <QSqlError>    //подключаем класс вывода ошибок SQL запросов
#include <QSqlQuery>    //подключаем класс обработки запросов к БД
#include <QDebug>

class Beta : public QObject
{
    Q_OBJECT
public:
    Beta();
    ~Beta();
signals:
    void transmitName(QVariant);
    void transmitSurname(QVariant);
    void transmitSecondName(QVariant);
    void exit();

public slots:
    void onBackButton();
    void onMeasurementButton();
    void onNameChanged(const QString &text);
    void onSurnameChanged(const QString& str);
    void onSecondNameChanged(const QString& str);
    void initDatabase();
private:
    QString* name;
    QString* surname;
    QString* secondName;
    QQmlApplicationEngine* this_engine;
    BetaMeasurementSettings* betaMesurementSettings;
    void updateDB();
};

#endif // BETA_H
