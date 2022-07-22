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



        //        ui->comboBox_3->addItem("Гр/с");
        //        ui->comboBox_3->addItem("Гр/мин");
        //        ui->comboBox_3->addItem("Гр/ч");
        //        ui->comboBox_4->addItem("Чувствительный");
        //        ui->comboBox_4->addItem("Средний");
        //        ui->comboBox_4->addItem("Грубый");

        //        ui->radioButton->setChecked(true);
        //        ui->comboBox_2->addItem("Ручной");
        //        ui->comboBox_2->addItem("Автоматический");
        //        ui->lineEdit->setText("20");
        //        ui->lineEdit_2->setText("750");
        //        ui->label_13->setText("99990");
        //        ui->lineEdit_3->setText("1");
        //        ui->lineEdit_4->setEnabled(false);
        //        ui->lineEdit_4->setVisible(false);
        //        ui->lineEdit_5->setEnabled(false);
        //        ui->lineEdit_5->setVisible(false);

        //        ui->lineEdit_5->setValidator(new QDoubleValidator(0.0, 1000.0, 5, ui->lineEdit_4)); //только цифры, 5 знаков после запятой

        //        ui->lineEdit_6->setEnabled(false);
        //        ui->lineEdit_6->setVisible(false);
        //        ui->lineEdit_7->setEnabled(false);
        //        ui->lineEdit_7->setVisible(false);

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


    betaMes = new BetaMeasurement;
    //betaMes->Beta(betaChamber);
    //---------------------------------------------------------------------------------------------------
//    //передаем эти параметры в конструктор вновь создаваемого объекта класса окна измерения (бета излучения):
//    Beta_measuring_measure* betaMesMes = new Beta_measuring_measure(this,Dimension,DimensionForTime,Regim,
//                                                                    TimesAutomatic,TimeAutomatic,Threashold,
//                                                                    TimeThreashold,DoseThreashold);
//    //---------------------------------------------------------------------------------------------------
//    betaMesMes->setModal(true);
//    betaMesMes->Beta(betaChamber); // вызываем функцию и передаем туда указатель на текущую объект бета камеры
//    betaMesMes->show();
    //--------------------------------------------------------------------------------------------------------------------
}
