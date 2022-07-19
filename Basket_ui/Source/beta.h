#ifndef BETA_H
#define BETA_H

#include <QObject>
#include <QSqlDatabase> //подключаем класс настроек для работы с БД
#include <QSqlError>    //подключаем класс вывода ошибок SQL запросов
#include <QSqlQuery>    //подключаем класс обработки запросов к БД
#include <QDebug>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
class Beta : public QObject
{
    Q_OBJECT
public:
    Beta(QQmlApplicationEngine* engine);
    ~Beta();
signals:
    void transmitName(QVariant);
    void transmitSurname(QVariant);
    void transmitSecondName(QVariant);

public slots:
    void onBackButton();
    void onNameChanged(const QString &text);
private:
    QString* name;
    QString* surname;
    QString* secondName;
    QQmlApplicationEngine* this_engine;


};

#endif // BETA_H
