#include "mainwindow.h"

MainWindow::MainWindow(QObject* info)
{
    QObject* exitButton = info->findChild<QObject*>("exitButton");
    QObject::connect(exitButton, SIGNAL(signalExitButton()),this,SLOT(onExitButton()));

    QObject* accessCodeSubmitButton = info->findChild<QObject*>("accessCodeSubmitButton");
    QObject::connect(accessCodeSubmitButton, SIGNAL(signalAccessCodeSubmitButton(QString))
                     ,this,SLOT(onAccessCodeSubmitButton(QString)));

    QSqlDatabase::addDatabase("QSQLITE","myDB");    //загружаем драйвер БД(SQLITE) и создаем имя подключения к БД
    QSqlDatabase db=QSqlDatabase::database("myDB"); //создаем объект БД и присваиваем ему имя подключения
    db.setDatabaseName("config.db"); //подключаемся к файлу config.db, если его нет создается новый файл базы данных с именем config.db (можно удалить тогда создастся заново)

    if(!db.open()) //открываем БД, если не открылась пишем предупреждение в консоль
    {        qDebug()<<"DB was not opened"<<db.lastError().text();  }

    QSqlQuery query(db);// создаем объект через который будут идти запросы к БД, инициализируем созданным объектом БД (db)


    //***************************************************************************************************************
    QString queryStr = "CREATE TABLE IF NOT EXISTS password (id INTEGER PRIMARY KEY CHECK (id=0),"             //создаем новую таблицу из одной строки т.к (id=0)
            "passVerifier TEXT(10),"                          //в которую заводим три колонки с текстовым содержимым
            "passManufacturer TEXT(10),"                      //пароль поверителя, пароль изготовителя
            "passCurrent TEXT(10))";                          //текущуй пароль
    //********************************************************************************************************************

    if(!query.exec(queryStr)) //передаем строку с указанием создать таблицу в метод exec() объекта query
    {qDebug()<<"unable execute query CREATE"<<query.lastError().text();}
    //queryStr = "INSERT INTO password (id,passVerifier, passManufacturer, passCurrent) VALUES (0,'КЕРМА','777','1')"; //Вставляем в таблицу строку (вставить можно только одну строку)
    //if(!query.exec(queryStr))
    //{qDebug()<<"unable execute query INSERT"<<query.lastError().text();}
    queryStr = "UPDATE password SET  passCurrent='1';";  // при загрузке меняем passCurrent на '1', чтобы по умолчанию загружался оператор (а не поверитель и изготовитель)
    if(!query.exec(queryStr))
    {qDebug()<<"unable execute query UPDATE"<<query.lastError().text();}
    db.close();
}

void MainWindow::onExitButton()
{
    qDebug() << "system(shutdown now)";
}

void MainWindow::onAccessCodeSubmitButton(QString str)
{
    qDebug() << "onAccessCodeSubmitButton  " << str;
}
