#include "mainwindow.h"

MainWindow::MainWindow(QQmlApplicationEngine* engine) : this_engine(engine) {
    createDatabase();

    QQmlComponent main_qml_comp(engine, QUrl(QStringLiteral("qrc:/main.qml")));
    QObject* info = main_qml_comp.create();

    //QObject* info = this_map.at("MainPage.qml");
    QObject *exitButton = info->findChild<QObject *>("exitButton");
    QObject::connect(exitButton, SIGNAL(signalExitButton()), this, SLOT(onExitButton()));

    QObject *accessCodeSubmitButton = info->findChild<QObject *>("accessCodeSubmitButton");
    QObject::connect(accessCodeSubmitButton, SIGNAL(signalAccessCodeSubmitButton(QString)), this,
                     SLOT(onAccessCodeSubmitButton(QString)));

    QObject *mainPage = info->findChild<QObject *>("mainPage");
    QObject::connect(this, SIGNAL(transmitNewText(QVariant)), mainPage, SLOT(checkCode(QVariant)));


    QObject *betaRadiationButton = info->findChild<QObject *>("betaRadiationButton");
    QObject::connect(betaRadiationButton, SIGNAL(signalBetaRadiationButton()),
            this, SLOT(onBetaRadiationButton()));
}

void MainWindow::onBetaRadiationButton() {
    //beta = std::make_unique<Beta>(t_info);
    beta = new Beta(this_engine);
    this_engine->rootContext()->setContextProperty("_cppApi", beta);
}

void MainWindow::onAccessCodeSubmitButton(QString str) {
    QString passCurrent{"1"}; //переменная в которую запишется текущий введенный пароль
    QString passManufacturer{""};
    QString passVerifier{""};
    // passCurrent = ui->lineEdit->text();
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()) {
            qDebug() << "db was not opened";
        }
        QSqlQuery query(db);
        QString queryStr = "UPDATE password SET passCurrent='%1'"; //изменяем passCurrent в таблице password
        QString queryStr1 = queryStr.arg(str); //вставляем вместо '%1' введенную строку
        if(!query.exec(queryStr1)) {
            qDebug() << "unable execute query UPDATE" << query.lastError().text();
        }
        queryStr = "SELECT * FROM password";
        if(!query.exec(queryStr)) //выполнить запрос на выбор всего(*) из таблицы password
        {
            qDebug() << "unable execute query SELECT" << query.lastError().text();
        }
        if(query.first()) // обращение к первой строке таблицы
        {
            passCurrent = query.value("passCurrent").toString();
            passManufacturer = query.value("passManufacturer").toString();
            passVerifier = query.value("passVerifier").toString();
        }
    }
    if(passCurrent == passManufacturer) {
        emit transmitNewText("Изготовитель");
    } else if(passCurrent == passVerifier) {
        emit transmitNewText("Поверитель");
    } else {
        emit transmitNewText("Оператор");
    }
}

void MainWindow::onExitButton() { qDebug() << "system(shutdown now)"; }

void MainWindow::createDatabase() {
    QSqlDatabase::addDatabase("QSQLITE", "myDB"); //загружаем драйвер БД(SQLITE) и создаем имя подключения к БД
    QSqlDatabase db = QSqlDatabase::database("myDB"); //создаем объект БД и присваиваем ему имя подключения
    db.setDatabaseName("config.db"); //подключаемся к файлу config.db, если его нет создается новый файл базы данных с
                                     //именем config.db (можно удалить тогда создастся заново)

    if(!db.open()) //открываем БД, если не открылась пишем предупреждение в консоль
    {
        qDebug() << "DB was not opened" << db.lastError().text();
    }

    QSqlQuery query(
        db); // создаем объект через который будут идти запросы к БД, инициализируем созданным объектом БД (db)

    //***************************************************************************************************************
    QString queryStr =
        "CREATE TABLE IF NOT EXISTS password (id INTEGER PRIMARY KEY CHECK (id=0)," //создаем новую таблицу из одной
                                                                                    //строки т.к (id=0)
        "passVerifier TEXT(10)," //в которую заводим три колонки с текстовым содержимым
        "passManufacturer TEXT(10)," //пароль поверителя, пароль изготовителя
        "passCurrent TEXT(10))";     //текущуй пароль
    //****************************************************************************************************************

    if(!query.exec(queryStr)) //передаем строку с указанием создать таблицу в метод exec() объекта query
    {
        qDebug() << "unable execute query CREATE" << query.lastError().text();
    }
    // queryStr = "INSERT INTO password (id,passVerifier, passManufacturer, passCurrent) VALUES (0,'КЕРМА','777','1')";
    // //Вставляем в таблицу строку (вставить можно только одну строку) if(!query.exec(queryStr)) {qDebug()<<"unable
    // execute query INSERT"<<query.lastError().text();}
    queryStr = "UPDATE password SET  passCurrent='1';"; // при загрузке меняем passCurrent на '1', чтобы по умолчанию
                                                        // загружался оператор (а не поверитель и изготовитель)
    if(!query.exec(queryStr)) {
        qDebug() << "unable execute query UPDATE" << query.lastError().text();
    }
    db.close();
}
