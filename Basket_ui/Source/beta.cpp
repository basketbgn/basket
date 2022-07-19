#include "beta.h"
#include "QThread"
Beta::Beta(QQmlApplicationEngine* engine){
    //QObject* info = this_map.at("Beta.qml");
    name = new QString("");
    surname = new QString("");
    secondName = new QString("");


    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"DB was not opened";}
        QSqlQuery query(db);
        QString queryStr = "SELECT * FROM fullName";
        if(!query.exec(queryStr))
        {qDebug()<<"unable execute query SELECT";}
        if(query.first()) {
            emit transmitName(query.value("name").toString());
            emit transmitSurname(query.value("surname").toString());
            emit transmitSecondName(query.value("patronymic").toString());
        }
    }
}

Beta::~Beta() {
    delete name; delete surname; delete secondName;
}



void Beta::onBackButton() {
    qDebug()<<"onBackButton";
    if(QSqlDatabase::contains("myDB"))
    {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open())
        {qDebug()<<"DB was not opened";}
        QSqlQuery query(db);
        QString queryStr;
        //if(!query.exec("DROP TABLE fullName"))
        //{qDebug()<<"unable execute query drop"<<query.lastError().text();}
        //queryStr = "CREATE TABLE IF NOT EXISTS fullName "
        //                   "(id INTEGER PRIMARY KEY CHECK (id=0),"
        //                   "surname TEXT(10),"
        //                   "name TEXT(10),"
        //                   "patronymic TEXT(10))";
        //if(!query.exec(queryStr))
        //{qDebug()<<"unable execute query CREATE"<<query.lastError().text();}
        //QString queryStr1 = "INSERT INTO fullName (id, surname, name, patronymic)"
        //                    "VALUES (0, '1', '2', '3')";
        //
        //if(!query.exec(queryStr1))
        //{qDebug()<<"unable execute query INSERT";}

        QString queryStr1 = "UPDATE fullName SET "
                        "surname = '%1',"
                        "name = '%2',"
                        "patronymic = '%3'";
        queryStr = queryStr1.arg(*surname)
                .arg(*name)
                .arg(*secondName);
        if(!query.exec(queryStr))
        {qDebug()<<"unable execute query UPDATE";}
    }
    delete this;
    //~Beta();
}

void Beta::onNameChanged(const QString &text)
{
    //emit transmitName("text" , "opa", "opa1");
    qDebug() << "text" << text;
    emit transmitName(text);
    emit transmitSurname(text);
    emit transmitSecondName(text);
}
