#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "beta.h"

#include <QDebug> //подключаем класс вывода отладочной информации в консоль
#include <QObject>
#include <QSqlDatabase> //подключаем класс настроек для работы с БД
#include <QSqlError>    //подключаем класс вывода ошибок SQL запросов
#include <QSqlQuery>    //подключаем класс обработки запросов к БД
#include <QQmlApplicationEngine>
#include <QQmlComponent>

class MainWindow : public QObject {
    Q_OBJECT
  public:
    MainWindow(QQmlApplicationEngine* engine);


  signals:
    void transmitNewText(QVariant);
  public slots:
    void onExitButton();
    void onAccessCodeSubmitButton(QString str);
    void onBetaRadiationButton();

  private:
    void createDatabase();
    //std::unique_ptr<Beta> beta;
    Beta* beta;
    QObject* t_info;

    std::map<QString, QObject*> this_map;
    QQmlApplicationEngine* this_engine;
};

#endif // MAINWINDOW_H
