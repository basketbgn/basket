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
    timerStart=new QTimer(this);
    connect(timerStart,&QTimer::timeout,this,&BetaMeasurement::startTimeOut); //коннект на ф-ю timeOut
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
    qDebug() << "backbutton";
}

void BetaMeasurement::startPressed() {
    qDebug() << "start";
    timer->start(1000);
}

void BetaMeasurement::timeOut() {
    //------------------------------------Время-------------------------------------------------------
    time++;
    emit sendTime(QString::number(time));
    //ui->label_3->setText(QString::number(time) + " c"); //отображение времени
    //------------------------------------Мощность дозы-------------------------------------------------------
    doseRate = beta->MPD(); //считываем измерение из класса Beta_chamber в Гр/с
    emit sendDoseRate(QString::number(doseRate, 'g', 4));
    //qDebug()<<beta->getIres();
    //qDebug()<<beta->MPD();
    //double currentDoseRate = doseRate*timeCoef; //для вывода на экран, Мощности Дозы в Гр/с, Гр/мин, Гр/ч
    //doseTo4(currentDoseRate,Dimension,ui->label_9,ui->label_2); //передаем в функцию вывода на экран:
    //значение (которое преобразуется),размерность,
    //указатель на label в который записывется преобразованная величина,
    //указатель на label в который записывется преобразованная размерность,

    //------------------------------------Доза-------------------------------------------------------
    dose+=doseRate;         // обнуляется при автоматическом измерении, используется для подсчета среднего по дозе
    emit sendDose(QString::number(dose, 'g', 4));
    doseForAuto+=doseRate;  // не обнуляется при автоматическом измерении, используется для рассчета СКО
    //doseTo4(dose,DimensionDose,ui->label_8,ui->label_7);

    //------------------------------------СКО и Среднее-------------------------------------------------------

    avDoseRate = (doseForAuto/time)*timeCoef;// - средняя величина мощности дозы
    emit sendAverageDoseRate(QString::number(avDoseRate, 'g', 4));
    //double avDoseRate = dose*timeCoef;
    //doseTo4(avDoseRate,Dimension,ui->label_22,ui->label_25); //выводим на экран среднее
    otkl += doseRate*doseRate*timeCoef*timeCoef; //сумма квадратов случайной величины
    if(time>0) {
        double z=sqrt((otkl/time)-avDoseRate*avDoseRate); //CKO по хитрой формуле: корень из D=(1/N)SUM(1,N,Xi^2)-M^2
        // формула получена на основании того что СКО - это корень из дисперсии
        // Дисперсия - математическое ожидание квадрата отклонения случайной величины от её математического ожидания
        // D=M[X-M(X)]^2 = M(X^2) - M^2(X); - особенное свойство которое везде доказывается
        // M(X^2) - для равновероятных событий является = (1/N)SUM(1,N,doseRate*doseRate)
        // Дисперсия равняется мат ожиданию квадрата случайной величины минус квадрат мат ожидания случайной величины
        // отсюда и получается данная формула: корень из D=(1/N)SUM(1,N,Xi^2)-(среднее)^2

        StandardDeviation=std::abs(z/avDoseRate); //под СКО подразумеваем СКО деленное на среднее и умножить на 100% (относительное отклонение от среднего)
        //ui->label_20->setText(QString::number(StandardDeviation*100,'f',3)+" %");
    }
    emit sendStandardDeviation(QString::number(StandardDeviation, 'g', 4));

//    //------------------------------Автоматическое измерение-------------------------------------------------------
//    //условие автоматического измерения (при автоматическом измерении пороги не срабатывают)
//    if(Regime==true&&TimeAutomatic!=0&&TimesAutomatic!=0) {
//        //autoMode(dose,timer,ui->label_17,ui->label_13);
//    } else {
//        // (если нет авто измерения проверяем пороги)
//        //------------------------------------Пороги-------------------------------------------------------
//        //timeThreashold(time,ui->label_21,timer);   //проверка на порог по времени
//        //doseThreashold(dose,ui->label_21,timer);   //проверка на порог по дозе
//    }
}

void BetaMeasurement::startTimeOut() {
    timer->start(1000);
    time=0;
    //ui->label_3->setText(QString::number(time));
    dose=0;
    otkl=0;
    doseForAuto=0;//обнуляем интегральные переменные чтобы не накапливалось
}

void BetaMeasurement::autoModeResult(double AverageDoseRate, double DoseRate_deviation_average,
                                     double AverageDose, double Dose_deviation_average) {
    autoInitialization ="Бета излучение\n" + chamberName +
            "\nКоличество измерений: "+QString::number(TimesAutomatic) +
            "\nВремя измерений: "+QString::number(TimeAutomatic)+" c";
//    autoResult = new Auto_measurement_result(this,value,integralValue, autoInitialization);
//    autoResult->setModal(true);
//    doseTo4(AverageDoseRate,Dimension,autoResult->avDoseRate,autoResult->avDoseRateDimension);//выводим значения в окне объекта другого класса
//    doseTo4(AverageDose,DimensionDose,autoResult->avDose,autoResult->avDoseDimension);        //выводим значения в окне объекта другого класса
//    autoResult->avDoseRateDeviation->setText(QString::number(DoseRate_deviation_average) +" %");
//    autoResult->avDoseDeviation->setText(QString::number(Dose_deviation_average) +" %");
//    autoResult->show();
}

