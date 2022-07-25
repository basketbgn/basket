#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "beta.h"
#include "vendorsettings.h"

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
    MainWindow();
    ~MainWindow();    
  signals:
    void transmitNewText(QVariant);
  public slots:
    void onExitButton();
    void onAccessCodeSubmitButton(const QString& str);
    void onBetaRadiationButton();
    void onVendorSettingsButton();
    void createDatabase();
  private:
    Beta* beta;
    VendorSettings* vendorSettings;
    QQmlApplicationEngine* this_engine;
};

#endif // MAINWINDOW_H
