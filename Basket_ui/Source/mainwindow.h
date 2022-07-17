#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QObject>
#include <QSqlDatabase>     //подключаем класс настроек для работы с БД
#include <QSqlQuery>        //подключаем класс обработки запросов к БД
#include <QSqlError>        //подключаем класс вывода ошибок SQL запросов
#include <QDebug>           //подключаем класс вывода отладочной информации в консоль

class MainWindow : public QObject
{
    Q_OBJECT
public:
    MainWindow(QObject* info);
public slots:
    void onExitButton();
    void onAccessCodeSubmitButton(QString str);
private:

};

#endif // MAINWINDOW_H
