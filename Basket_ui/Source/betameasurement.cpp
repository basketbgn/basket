#include "betameasurement.h"

BetaMeasurement::BetaMeasurement(const QString dimension,const int dimensionForTime,
                                 bool regime, const uint timesAutomatic,
                                 const uint timeAutomatic, const uint8_t threashold,
                                 const uint timeThreashold, const double doseThreashold) :
    Abstract_measurement_measurement(dimension, dimensionForTime,regime,
                                     timesAutomatic, timeAutomatic,
                                     threashold, timeThreashold, doseThreashold)
{
    this_engine = Engine::This_engine;
    this_engine->rootContext()->setContextProperty("_cppApi_BetaMeasurement", this);
}

BetaMeasurement::~BetaMeasurement() {
}

void BetaMeasurement::init() {
    timer=new QTimer(this);
    connect(timer,&QTimer::timeout,this,&BetaMeasurement::timeOut); //коннект на ф-ю timeOut    
    emit sendMode(Regime);
}



//прием указателя на объект бета камеры (чтобы можно было бы обращаться к объекту из этого класса)
void BetaMeasurement::Beta(Beta_chamber* x) {
    beta = x;
    chamberName = beta->getChamberName();
    //if(QSqlDatabase::contains("myDB"))  //
    //{
    //    QSqlDatabase db=QSqlDatabase::database("myDB");
    //    db.setDatabaseName("config.db");
    //    if(!db.open()){qDebug()<<"db was not opened";}
    //    QSqlQuery query(db);
    //    QString qStr="SELECT *FROM betaChambers WHERE name='%1'";
    //    QString qStr1=qStr.arg(chamberName);
    //    if(!query.exec(qStr1)){qDebug()<<"unable execute query SELECT sensibility FROM betaChambers WHERE name='%1'";}
    //    if (query.first())
    //    {
    //****************************************************************************
    //        //отсюда берем характеристики (имя камеры, напряжение...) которые отобразим в окне измерения
    //****************************************************************************
    //    }
    //    db.close();
    //}
}

void BetaMeasurement::onBackButton() {    
    delete this;
}

void BetaMeasurement::startPressed() {
    emit sendAdditionalInfo("");
    timer->start(1000);
    time=0;
    dose=0;
    otkl=0;
    doseForAuto=0;//обнуляем интегральные переменные чтобы не накапливалось
}

void BetaMeasurement::stopPressed() {
    timer->stop();
}

void BetaMeasurement::timeOut() {
    //------------------------------------Время-------------------------------------------------------
    time++;
    emit sendTime(QString::number(time));
    //------------------------------------Мощность дозы-------------------------------------------------------
    doseRate = beta->MPD(); //считываем измерение из класса Beta_chamber в Гр/с
    qDebug()<<beta->getIres();
    qDebug()<<beta->MPD();
    double currentDoseRate = doseRate * timeCoef; //для вывода на экран, Мощности Дозы в Гр/с, Гр/мин, Гр/ч

    QString valueCurrentDoseRate;
    QString currentDimension;
    doseTo4(currentDoseRate, Dimension, valueCurrentDoseRate, currentDimension, 0, 0); //передаем в функцию вывода на экран:
    emit sendDoseRate(valueCurrentDoseRate);
    //qDebug() << "valueCurrentDoseRate" << valueCurrentDoseRate << "currentDimension" << currentDimension;    
    emit sendDimension(currentDimension);
    //значение (которое преобразуется),размерность,
    //указатель на label в который записывется преобразованная величина,
    //указатель на label в который записывется преобразованная размерность,

    //------------------------------------Доза-------------------------------------------------------
    dose += doseRate;         // обнуляется при автоматическом измерении, используется для подсчета среднего по дозе

    doseForAuto += doseRate;  // не обнуляется при автоматическом измерении, используется для рассчета СКО
    QString valueCurrentDose;
    QString currentDimensionDose;
    doseTo4(dose, DimensionDose, valueCurrentDose, currentDimensionDose);
    emit sendDose(valueCurrentDose);
    emit sendDoseDimension(currentDimensionDose);
    //qDebug() << "valueCurrentDose" << valueCurrentDose << "currentDimensionDose" << currentDimensionDose;

    //------------------------------------СКО и Среднее-------------------------------------------------------

    avDoseRate = (doseForAuto/time)*timeCoef;// - средняя величина мощности дозы    
    //double avDoseRate = dose * timeCoef;

    QString valueCurrentAverageDoseRate;
    QString currentDimensionAverageDoseRate;
    doseTo4(avDoseRate, Dimension, valueCurrentAverageDoseRate, currentDimensionAverageDoseRate); //выводим на экран среднее
    emit sendAverageDoseRate(valueCurrentAverageDoseRate);
    emit sendAverageDoseRateDimension(currentDimensionAverageDoseRate);
    //qDebug() << "valueCurrentAverageDoseRate" << valueCurrentAverageDoseRate
    //         << "currentDimensionAverageDoseRate" << currentDimensionAverageDoseRate;
    otkl += doseRate * doseRate * timeCoef * timeCoef; //сумма квадратов случайной величины
    if(time > 0) {        
        //CKO по хитрой формуле: корень из D=(1/N)SUM(1,N,Xi^2)-M^2
        double z = sqrt((otkl / time) - (avDoseRate * avDoseRate));        
        //qDebug() << "(otkl / time) - (avDoseRate * avDoseRate)" << (otkl / time) - (avDoseRate * avDoseRate);
        // формула получена на основании того что СКО - это корень из дисперсии
        // Дисперсия - математическое ожидание квадрата отклонения случайной величины от её математического ожидания
        // D=M[X-M(X)]^2 = M(X^2) - M^2(X); - особенное свойство которое везде доказывается
        // M(X^2) - для равновероятных событий является = (1/N)SUM(1,N,doseRate*doseRate)
        // Дисперсия равняется мат ожиданию квадрата случайной величины минус квадрат мат ожидания случайной величины
        // отсюда и получается данная формула: корень из D=(1/N)SUM(1,N,Xi^2)-(среднее)^2
        //под СКО подразумеваем СКО деленное на среднее и умножить на 100% (относительное отклонение от среднего)
        StandardDeviation = std::abs(z / avDoseRate);
        //qDebug() << "StandardDeviation=" << StandardDeviation << " z=" << z << " avDoseRate=" << avDoseRate;
        emit sendStandardDeviation(QString::number(StandardDeviation, 'g', 4));
        //ui->label_20->setText(QString::number(StandardDeviation*100,'f',3)+" %");
    }


//    //------------------------------Автоматическое измерение-------------------------------------------------------
//    //условие автоматического измерения (при автоматическом измерении пороги не срабатывают)
    if(Regime == true && TimeAutomatic !=0 && TimesAutomatic != 0) {
        QString autoTime{""};
        QString autoTimes{""};
        autoMode(dose, timer, autoTime, autoTimes);
        emit sendAdditionalInfo("Время одного измерения " + autoTime +
                                "\nКоличество измерений " + autoTimes);
        // emit signals to show automatic mode time
    } else {
        // (если нет авто измерения проверяем пороги)
        //------------------------------------Пороги-------------------------------------------------------
        QString threashold{""};
        timeThreashold(time, threashold, timer);   //проверка на порог по времени
        doseThreashold(dose, threashold, timer);   //проверка на порог по дозе
        if(threashold != "") {
            emit sendAdditionalInfo(threashold);
        }
    }
}

void BetaMeasurement::autoModeResult(double AverageDoseRate, double DoseRate_deviation_average,
                                     double AverageDose, double Dose_deviation_average) {
    autoInitialization ="Бета излучение\n" + chamberName +
            "\nКоличество измерений: "+QString::number(TimesAutomatic) +
            "\nВремя измерений: "+QString::number(TimeAutomatic)+" c";
//    autoResult = new Auto_measurement_result(this,value,integralValue, autoInitialization);
//    autoResult->setModal(true);
    QString avDoseRate;
    QString avDoseRateDimension;
    doseTo4(AverageDoseRate, Dimension, avDoseRate, avDoseRateDimension);//выводим значения в окне объекта другого класса
    QString avDose;
    QString avDoseDimension;
    doseTo4(AverageDose, DimensionDose, avDose, avDoseDimension);
    autoInitialization += "\n Средняя МПД\t" + avDoseRate + " \t" + avDoseRateDimension +
            "\tСКО " + QString::number(DoseRate_deviation_average) +" %";
    autoInitialization += "\n Средняя ПД\t" + avDose + " \t" + avDoseDimension +
            "\tСКО " + QString::number(Dose_deviation_average) +" %";
    emit sendAutoResult(autoInitialization);
//    autoResult->avDoseRateDeviation->setText(QString::number(DoseRate_deviation_average) +" %");
//    autoResult->avDoseDeviation->setText(QString::number(Dose_deviation_average) +" %");
//    autoResult->show();
}

