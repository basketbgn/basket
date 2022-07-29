//**************************************** настройки изготовителя - настройки электрометра *********************

#include "settings_electrometer.h"

Settings_electrometer::Settings_electrometer() {
    this_engine = Engine::This_engine;
    this_engine->rootContext()->setContextProperty("_cppApi_ElectrometerSettings", this);
}

Settings_electrometer::~Settings_electrometer() {
    qDebug() << "~Settings_electrometer";
}

void Settings_electrometer::init() {
    //ui->pushButton_3->setEnabled(false);
    //ui->pushButton_3->setVisible(false); //делаем невидимой кнопку добавления строки
    //создаем таблицу если не была создана, и выводим названия камер в listWidget
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db=QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr="CREATE TABLE IF NOT EXISTS electrometer(   id INTEGER PRIMARY KEY CHECK (id=0),"   //таблица из одной строки
                "periodRS232 TEXT(10),"
                                                              "R1 TEXT(10),"
                                                              "referenceVoltage TEXT(10),"
                                                              "heatingTime TEXT(10),"
                                                              "changeTimeout TEXT(10),"
                                                              "testTimeout TEXT(10),"
                                                              "countsAver TEXT(10),"
                                                              "minDAC TEXT(10),"
                                                              "maxDAC TEXT(10),"
                                                              "minRefVolt TEXT(10),"
                                                              "maxRefVolt TEXT(10),"
                                                              "minR2 TEXT(10),"
                                                              "maxR2 TEXT(10),"
                                                              "minR3 TEXT(10),"
                                                              "maxR3 TEXT(10),"
                                                              "minI TEXT(10),"
                                                              "maxI TEXT(10))";
        if(!query.exec(qStr)){qDebug()<<"unable execute query CREATE table electrometer"<<query.lastError().text();}
        //if(!query.exec("DROP TABLE electrometer")){qDebug()<<"unable execute query DELETE table electrometer"<<query.lastError().text();}
        qStr = "SELECT *FROM electrometer";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT table electrometer"<<query.lastError().text();}
        if(query.first()) {
            *periodRS232 = query.value("periodRS232").toString();
            *R1 = query.value("R1").toString();
            *referenceVoltage = query.value("referenceVoltage").toString();
            *heatingTime = query.value("heatingTime").toString();
            *changeTimeout = query.value("changeTimeout").toString();
            *testTimeout = query.value("testTimeout").toString();
            *countsAver = query.value("countsAver").toString();
            *minDAC = query.value("minDAC").toString();
            *maxDAC = query.value("maxDAC").toString();
            *minRefVolt = query.value("minRefVolt").toString();
            *maxRefVolt = query.value("maxRefVolt").toString();
            *minR2 = query.value("minR2").toString();
            *maxR2 = query.value("maxR2").toString();
            *minR3 = query.value("minR3").toString();
            *maxR3 = query.value("maxR3").toString();
            *minI = query.value("minI").toString();
            *maxI = query.value("maxI").toString();
            emit sendInitValues(*periodRS232,
                                *R1,
                                *referenceVoltage,
                                *heatingTime,
                                *changeTimeout,
                                *testTimeout,
                                *countsAver,
                                *minDAC,
                                *maxDAC,
                                *minRefVolt,
                                *maxRefVolt,
                                *minR2,
                                *maxR2,
                                *minR3,
                                *maxR3,
                                *minI,
                                *maxI);
        }
    }
}

//INSERT - скрытая кнопка (нужна для заполнения первой строки таблицы)
void Settings_electrometer::on_pushButton_3_clicked() {
    //создаем таблицу если не была создана, и выводим названия камер в listWidget
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db=QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr="INSERT INTO electrometer (id,"
                                     "periodRS232 ,"
                                     "R1,"
                                     "referenceVoltage,"
                                     "heatingTime,"
                                     "changeTimeout,"
                                     "testTimeout,"
                                     "countsAver,"
                                     "minDAC,"
                                     "maxDAC,"
                                     "minRefVolt,"
                                     "maxRefVolt,"
                                     "minR2,"
                                     "maxR2,"
                                     "minR3,"
                                     "maxR3,"
                                     "minI,"
                                     "maxI)"
             "VALUES(0,'%1','%2','%3','%4','%5','%6','%7','%8','%9','%10','%11','%12','%13','%14','%15','%16','%17')";
        QString qStr1=qStr.arg(*periodRS232)
                .arg(*R1)
                .arg(*referenceVoltage)
                .arg(*heatingTime)
                .arg(*changeTimeout)
                .arg(*testTimeout)
                .arg(*countsAver)
                .arg(*minDAC)
                .arg(*maxDAC)
                .arg(*minRefVolt)
                .arg(*maxRefVolt)
                .arg(*minR2)
                .arg(*maxR2)
                .arg(*minR3)
                .arg(*maxR3)
                .arg(*minI)
                .arg(*maxI);
        if(!query.exec(qStr1)){qDebug()<<"unable execute query INSERT"<<query.lastError().text();}
    }
}

void Settings_electrometer::onOkButton() {
    //создаем таблицу если не была создана, и выводим названия камер в listWidget
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db=QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr="UPDATE electrometer SET "
                                     "periodRS232='%1',"
                                     "R1='%2' ,"
                                     "referenceVoltage='%3',"
                                     "heatingTime='%4',"
                                     "changeTimeout='%5',"
                                     "testTimeout='%6',"
                                     "countsAver='%7',"
                                     "minDAC='%8',"
                                     "maxDAC='%9',"
                                     "minRefVolt='%10',"
                                     "maxRefVolt='%11',"
                                     "minR2='%12',"
                                     "maxR2='%13',"
                                     "minR3='%14',"
                                     "maxR3='%15',"
                                     "minI='%16',"
                                     "maxI='%17'";
        QString qStr1=qStr.arg(*periodRS232)
                .arg(*R1)
                .arg(*referenceVoltage)
                .arg(*heatingTime)
                .arg(*changeTimeout)
                .arg(*testTimeout)
                .arg(*countsAver)
                .arg(*minDAC)
                .arg(*maxDAC)
                .arg(*minRefVolt)
                .arg(*maxRefVolt)
                .arg(*minR2)
                .arg(*maxR2)
                .arg(*minR3)
                .arg(*maxR3)
                .arg(*minI)
                .arg(*maxI);
        if(!query.exec(qStr1)){qDebug()<<"unable execute query update"<<query.lastError().text();}
    }
    //delete this;
}

//назад
void Settings_electrometer::onBackButton() {
    qDebug() << "onBAckButton";
    delete this;
}

void Settings_electrometer::onPeriodRS232(const QString &s) {
    *periodRS232 = s;
}

void Settings_electrometer::onR1(const QString &s) {
    *R1 = s;
}

void Settings_electrometer::onReferenceVoltage(const QString &s) {
    *referenceVoltage = s;
}

void Settings_electrometer::onHeatingTime(const QString &s) {
    *heatingTime = s;
}

void Settings_electrometer::onChangeTimeout(const QString &s) {
    *changeTimeout = s;
}

void Settings_electrometer::onTestTimeout(const QString &s) {
    *testTimeout = s;
}

void Settings_electrometer::onCountsAver(const QString &s) {
    *countsAver = s;
}

void Settings_electrometer::onMinDAC(const QString &s) {
    *minDAC = s;
}

void Settings_electrometer::onMaxDAC(const QString &s) {
    *maxDAC = s;
}

void Settings_electrometer::onMinRefVolt(const QString &s) {
    *minRefVolt = s;
}

void Settings_electrometer::onMaxRefVolt(const QString &s) {
    *maxRefVolt = s;
}

void Settings_electrometer::onMinR2(const QString &s) {
    *minR2 = s;
}

void Settings_electrometer::onMaxR2(const QString &s) {
    *maxR2 = s;
}

void Settings_electrometer::onMinR3(const QString &s) {
    *minR3 = s;
}

void Settings_electrometer::onMaxR3(const QString &s) {
    *maxR3 = s;
}

void Settings_electrometer::onMinI(const QString &s) {
    *minI = s;
}

void Settings_electrometer::onMaxI(const QString &s) {
    *maxI = s;
}
