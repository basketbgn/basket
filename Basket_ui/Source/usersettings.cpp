#include "usersettings.h"

UserSettings::UserSettings() {
    this_engine = Engine::This_engine;
    this_engine->rootContext()->setContextProperty("_cppApi_UserSettings", this);
}

UserSettings::~UserSettings() {

}

void UserSettings::init() {
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db=QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr = "CREATE TABLE IF NOT EXISTS SourceChoice (id INTEGER PRIMARY KEY CHECK (id=0),"             //создаем новую таблицу из одной строки т.к (id=0)
                "emulator BOOLEAN)";
        if(!query.exec(qStr)){qDebug()<<"unable execute query CREATE table SourceChoice"<<query.lastError().text();}
//        qStr = "INSERT INTO SourceChoice (id,emulator) VALUES (0,1)";
//        if(!query.exec(qStr)){qDebug()<<"unable execute query INSERT in table SourceChoice"<<query.lastError().text();}

        qStr = "SELECT *FROM SourceChoice";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT table SourceChoice"<<query.lastError().text();}
        if(query.first()) {
            IsEmulatorOrDetector = (query.value("emulator").toBool()); //получаем значение из БД 1-эмулятор 0-детектор
        }
        db.close();
    }
    if (IsEmulatorOrDetector) {
        emit setChecked(true);
    } else {
        emit setChecked(false);
    }
}

void UserSettings::onBackButton() {
    delete this;
}

void UserSettings::onSendChecked(bool state) {
    IsEmulatorOrDetector = state;
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr ="";
        if (IsEmulatorOrDetector) {
            qStr="UPDATE SourceChoice SET emulator=1";  //если выбран эмулятор записать в переменную emulator 1
        }
        else {qStr="UPDATE SourceChoice SET emulator=0";} //выбран детектор
        if(!query.exec(qStr)){qDebug()<<"unable execute query UPDATE table SourceChoice"<<query.lastError().text();}
        db.close();
    }
    emit setChecked(IsEmulatorOrDetector);
}
