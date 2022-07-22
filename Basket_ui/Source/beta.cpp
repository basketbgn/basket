#include "beta.h"

Beta::Beta(){
    this_engine = Engine::This_engine;
    this_engine->rootContext()->setContextProperty("_cppApi_Beta", this);

    name = new QString("");
    surname = new QString("");
    secondName = new QString("");

}

Beta::~Beta() {
    delete name; delete surname; delete secondName;
}

void Beta::onBackButton() {    
    updateDB();
    this->~Beta();
}

void Beta::onMeasurementButton() {
    betaMesurementSettings = new BetaMeasurementSettings;
    updateDB();
}

void Beta::onNameChanged(const QString &str) {
    *name = str;
}
void Beta::onSurnameChanged(const QString& str) {
    *surname = str;
}
void Beta::onSecondNameChanged(const QString& str) {
    *secondName = str;
}

void Beta::initDatabase()
{
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"DB was not opened";}
        QSqlQuery query(db);
        QString queryStr = "SELECT * FROM fullName";
        if(!query.exec(queryStr))
        {qDebug()<<"unable execute query SELECT";}
        if(query.first()) {
            *name = query.value("name").toString();
            *surname = query.value("surname").toString();
            *secondName = query.value("patronymic").toString();
        }
    }
    emit transmitName(*name);
    emit transmitSurname(*surname);
    emit transmitSecondName(*secondName);
}

void Beta::updateDB() {
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open())
        {qDebug()<<"DB was not opened";}
        QSqlQuery query(db);
        QString queryStr;
        //if(!query.exec("DROP TABLE fullName"))
        //{qDebug()<<"unable execute query drop"<<query.lastError().text();}
        queryStr = "CREATE TABLE IF NOT EXISTS fullName "
                           "(id INTEGER PRIMARY KEY CHECK (id=0),"
                           "surname TEXT(10),"
                           "name TEXT(10),"
                           "patronymic TEXT(10))";
        if(!query.exec(queryStr))
        {qDebug()<<"unable execute query CREATE"<<query.lastError().text();}

//        QString queryStr1 = "INSERT INTO fullName (id, surname, name, patronymic)"
//                            "VALUES (0, '1', '2', '3')";
//        if(!query.exec(queryStr1))
//        {qDebug()<<"unable execute query INSERT";}

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
}
