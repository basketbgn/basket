#include "mainwindow.h"

MainWindow::MainWindow() {
    this_engine = Engine::This_engine;
    this_engine->rootContext()->setContextProperty("_cppApi_MainWindow", this);
}
MainWindow::~MainWindow() {}

void MainWindow::onBetaRadiationButton() {
    beta = new Beta;
}

void MainWindow::onVendorSettingsButton() {
    vendorSettings = new VendorSettings;
}

void MainWindow::onAccessCodeSubmitButton(const QString& str) {
    QString passCurrent{"1"}; //переменная в которую запишется текущий введенный пароль
    QString passManufacturer{""};
    QString passVerifier{""};
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
        //выполнить запрос на выбор всего(*) из таблицы password
        if(!query.exec(queryStr)) {
            qDebug() << "unable execute query SELECT" << query.lastError().text();
        }
        // обращение к первой строке таблицы
        if(query.first()) {
            passCurrent = query.value("passCurrent").toString();
            passManufacturer = query.value("passManufacturer").toString();
            passVerifier = query.value("passVerifier").toString();
        }
    }
    QString currentPassword;
    if(passCurrent == passManufacturer) {
        emit transmitNewText("Изготовитель");
        currentPassword = "Vendor";
        Password::instance()->setCurrentPassword(currentPassword);
    } else if(passCurrent == passVerifier) {
        emit transmitNewText("Поверитель");
        currentPassword = "Verifier";
        Password::instance()->setCurrentPassword(currentPassword);
    } else {
        emit transmitNewText("Оператор");
        currentPassword = "Operator";
        Password::instance()->setCurrentPassword(currentPassword);
    }

}

void MainWindow::onExitButton() {
    qDebug() << "system(shutdown now)";
    exit(0);
}

void MainWindow::createDatabase() {
    Password::instance();
    QSqlDatabase::addDatabase("QSQLITE", "myDB"); //загружаем драйвер БД(SQLITE) и создаем имя подключения к БД
    QSqlDatabase db = QSqlDatabase::database("myDB"); //создаем объект БД и присваиваем ему имя подключения
    db.setDatabaseName("config.db"); //подключаемся к файлу config.db, если его нет создается новый файл базы данных с
                                     //именем config.db (можно удалить тогда создастся заново)
    //открываем БД, если не открылась пишем предупреждение в консоль
    if(!db.open()) {
        qDebug() << "DB was not opened" << db.lastError().text();
    }
     // создаем объект через который будут идти запросы к БД, инициализируем созданным объектом БД (db)
    QSqlQuery query(db);

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
//     queryStr = "INSERT INTO password (id,passVerifier, passManufacturer, passCurrent) VALUES (0,'КЕРМА','777','1')";
//    // //Вставляем в таблицу строку (вставить можно только одну строку)
//    if(!query.exec(queryStr)) {qDebug()<<"unable execute query INSERT"<<query.lastError().text();}
    queryStr = "UPDATE password SET  passCurrent='1';"; // при загрузке меняем passCurrent на '1', чтобы по умолчанию
                                                        // загружался оператор (а не поверитель и изготовитель)
    if(!query.exec(queryStr)) {
        qDebug() << "unable execute query UPDATE" << query.lastError().text();
    }
    db.close();
}
