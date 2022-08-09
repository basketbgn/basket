#ifndef BETA_H
#define BETA_H

#include "engine.h"
#include "betameasurementsettings.h"
#include "electrometer_test.h"
#include "averageadc.h"

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
    void sendTestPassed(bool);
public slots:
    void onBackButton();
    void onMeasurementButton();
    void onHardwareTestButton();
    void onNameChanged(const QString &text);
    void onSurnameChanged(const QString& str);
    void onSecondNameChanged(const QString& str);
    void initDatabase();
    void isTestPassed(bool state);
private:
    AverageADC* globalPointerForAverageAdc{nullptr};
    QString* name;
    QString* surname;
    QString* secondName;
    QQmlApplicationEngine* this_engine;
    BetaMeasurementSettings* betaMesurementSettings;
    Electrometer_test* electrometerTest;
    bool TestPassed = false;
    void updateDB();
};

#endif // BETA_H
