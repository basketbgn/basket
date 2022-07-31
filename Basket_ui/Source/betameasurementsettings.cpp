#include "betameasurementsettings.h"

BetaMeasurementSettings::BetaMeasurementSettings() {
    this_engine = Engine::This_engine;
    this_engine->rootContext()->setContextProperty("_cppApi_BetaMeasurementSettings", this);
}

BetaMeasurementSettings::~BetaMeasurementSettings() {

}

void BetaMeasurementSettings::init() {    
    emit sendPassword(Password::instance()->getCurrentPassword());
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr="SELECT *FROM betaChambers";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT *FROM table betaChambers";}
        QList<QString> strList;
        //выполняем запросы поочереди в цикле (начиная с первого)
        while(query.next()) {
            strList.append(query.value("name").toString()+" дата поверки: "+query.value("VerificationDate").toString());
        }
        // send to qml
        emit sendChambersList(strList);

        QString queryS1 = "";
        QString queryS = "SELECT * FROM fullName";
        if(!query.exec(queryS))
        { qDebug()<<"unable execute query SELECT"; }
        QString name;
        if(query.first()) {
            name = query.value("surname").toString()+
                    " "+query.value("name").toString()+
                    " "+query.value("patronymic").toString();
        }
        emit transmitName(name);
        db.close();
    }
}

void BetaMeasurementSettings::onBackButton() {
    delete this;
}

void BetaMeasurementSettings::onCalibrationButton(const QString& range,
                                                  bool controlCompensation,
                                                  const QString& temperature,
                                                  const QString& atmosphericPressureMercury,
                                                  const QString& correctionFactor,
                                                  const QString& chamberComboBoxName) {

    //флаг выбора сопротивления обратной связи (0-R3-чувствительный),(1-R2-средний),(2-R1-грубый)
    uint8_t iR = (range == "Чувствительный") ? 0 : (range == "Средний") ? 1 : 2;;
    bool Comp = controlCompensation;
    double Temp = temperature.toDouble();
    double P = atmosphericPressureMercury.toDouble();
    double CorrF = correctionFactor.toDouble();
    const QString & chamName = chamberComboBoxName;

    //----------------------------------------------------------------------------------------------
    //передаем установленные параметры из данного окна в конструктор объекта класса бета камеры
    //объект класса Beta_chamber наследуется от класса Ichamber, в котором реализован эмулятор
    betaChamber = new Beta_chamber(iR,Comp,Temp,P,CorrF,chamName);
    connect(this, &BetaMeasurementSettings::sendToComSig, betaChamber, &Beta_chamber::setVoltageSlot);
    //-----------------------------------------------------------------------------------------------

    betaVer = new Beta_verify;
    betaVer->getBetaChamber(betaChamber);

    //----------  Управление электрометром: подача высокого, упраление реле резистор отвечающего за диапазон ------------
    QString str = chamName;
    int x = str.indexOf(" ");
    QString chamName1 = str.left(x);
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr = "SELECT * FROM betaChambers WHERE name='%1'";
        QString qStr1 = qStr.arg(chamName1);
        if(!query.exec(qStr1)){qDebug()<<"unable execute query SELECT FROM betaChambers WHERE name='%1";}
        if(query.first()) {
            voltage = query.value("voltage").toInt();
        }
        db.close();
    }

    QByteArray byteVolt;
    voltHex volthex;
    byteVolt=volthex.intVolt(voltage); // - через отдельный класс переводим напряжение в цифрах в hex код для посылки в СОМ порт (7х8х)
    //qDebug()<<QString::number(byteVolt[0],16)<<QString::number(byteVolt[1],16);
    //qDebug()<<voltage<<" "<<byteVolt.toHex();
    emit sendToComSig(byteVolt);
}

void BetaMeasurementSettings::onMeasurementButton(const QString& dimension,
                                                  const QString& dimensionForTime,
                                                  const QString& mode,
                                                  const QString& numberOFMeasurements,
                                                  const QString& timeOfOneMeasurement,
                                                  const QString& thresholds,
                                                  const QString& timeThreashold,
                                                  const QString& doseThreashold,

                                                  const QString& range,
                                                  bool controlCompensation,
                                                  const QString& temperature,
                                                  const QString& atmosphericPressureMercury,
                                                  const QString& correctionFactor,
                                                  const QString& chamberComboBoxName) {
    qDebug() << dimension << dimensionForTime << mode << numberOFMeasurements <<
                timeOfOneMeasurement << thresholds << timeThreashold << doseThreashold <<
                range << controlCompensation << temperature << atmosphericPressureMercury <<
                chamberComboBoxName;
    uint8_t iR = (range == "Чувствительный") ? 0 : (range == "Средний") ? 1 : 2;
    bool Comp = controlCompensation;
    double Temp = temperature.toDouble();
    double P = atmosphericPressureMercury.toDouble();
    double CorrF = correctionFactor.toDouble();
    const QString & chamName = chamberComboBoxName;

    betaChamber = new Beta_chamber(iR, Comp, Temp, P, CorrF, chamName);

    int dimensionTime = 0;
    int pos = dimensionForTime.lastIndexOf(QChar('/'));
    QString tempStr = dimensionForTime.right(pos);
    if(tempStr == "/с") {
        dimensionTime = 0;
    } else if(tempStr == "/мин") {
        dimensionTime = 1;
    } else if(tempStr == "/ч") {
        dimensionTime = 2;
    }
    bool modeTemp = (mode == "Ручной") ? 0 : 1;
    uint8_t threasholdTemp = thresholds == ("По дозе") ? 2 : ("По времени, с") ? 1 : 0;

    betaMes = new BetaMeasurement(dimension, dimensionTime, modeTemp,
                                  numberOFMeasurements.toInt(), timeOfOneMeasurement.toInt(),
                                  threasholdTemp, timeThreashold.toInt()/*, doseThreashold.toInt()*/);
    betaMes->Beta(betaChamber);
    //----------  Управление электрометром: подача высокого, упраление реле резистор отвечающего за диапазон ------------
    QString str = chamName;
    int x = str.indexOf(" ");
    QString chamName1 = str.left(x);
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr = "SELECT * FROM betaChambers WHERE name='%1'";
        QString qStr1 = qStr.arg(chamName1);
        if(!query.exec(qStr1)){qDebug()<<"unable execute query SELECT FROM betaChambers WHERE name='%1";}
        if(query.first()) {
            voltage = query.value("voltage").toInt();
        }
        db.close();
    }

    QByteArray byteVolt;
    voltHex volthex;
    byteVolt=volthex.intVolt(voltage); // - через отдельный класс переводим напряжение в цифрах в hex код для посылки в СОМ порт (7х8х)
    //qDebug()<<QString::number(byteVolt[0],16)<<QString::number(byteVolt[1],16);
    //qDebug()<<voltage<<" "<<byteVolt.toHex();
    emit sendToComSig(byteVolt);
}
