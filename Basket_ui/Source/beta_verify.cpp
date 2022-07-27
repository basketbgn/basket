//**************************** калибровка камер бета излучения ********************************
#include "beta_verify.h"

Beta_verify::Beta_verify() {
    this_engine = Engine::This_engine;
    this_engine->rootContext()->setContextProperty("_cppApi_BetaCalibration", this);    
}

Beta_verify::~Beta_verify() {
    delete timer;
    delete startTimer;
    delete betaChamber;
    delete dimensionsList;
}

void Beta_verify::init() {
    timer = new QTimer(this);
    connect(timer,&QTimer::timeout,this,&Beta_verify::timeOut);
    startTimer = new QTimer(this);
    connect(startTimer,&QTimer::timeout,this,&Beta_verify::startTimeOut);

    dimensionsList = new QStringList;
    dimensionsList->append("Гр/с"); dimensionsList->append("мГр/с");
    dimensionsList->append("Гр/ч"); dimensionsList->append("мГр/ч");
    emit sendListModel(*dimensionsList);
//    QEventLoop loop;
//    QTimer::singleShot(1000, &loop, SLOT(quit()));
//    loop.exec();
}

void Beta_verify::onBackButton() {
    delete this;
}
//кропка старт
void Beta_verify::startPressed() {
    startTimer->setSingleShot(true);
    startTimer->start(1000);
    Isum=0;
    time=0;
    otkl=0;
    //ui->label_3->setText("ПРОГРЕВ!");
}
void Beta_verify::startTimeOut() {
    timer->start(1000);
}

void Beta_verify::stopPressed() {
    timer->stop();
    sendSensibility();
}

void Beta_verify::onSaveButton() {
    if (sensibility == ""){emit sendWarningMsg();}
    else
    {
        if(QSqlDatabase::contains("myDB")) {
            QSqlDatabase db = QSqlDatabase::database("myDB");
            db.setDatabaseName("config.db");
            if(!db.open()){qDebug()<<"db was not opened";}
            QSqlQuery query(db);
            QString qStr="UPDATE betaChambers SET sensibility='%1' WHERE name='%2'";
            QString qStr1=qStr.arg(sensibility).arg(chamberName);
            if(!query.exec(qStr1)){qDebug()<<"unable execute query UPDATE betaChambers";db.lastError().text();}
            db.close();
        }
    }
}

void Beta_verify::onSendDoseRate(const QString &str) {
    currentDoseRate = std::move(str);
    sendSensibility();
}

void Beta_verify::onSendCurrentIndex(const QString &i) {
    currentIndex = i.toUInt();
    sendSensibility();
}

void Beta_verify::getBetaChamber(Beta_chamber *beta) {
    betaChamber = beta;
    chamberName = betaChamber->getChamberName();
}

void Beta_verify::sendSensibility() {
    if(!time){
        // do nothing
    }
    else {
        double I = avI;
        QString str = currentDoseRate; //считываем порог по дозе в переменную
        str.replace(",", ".");  // меняем запятые на точки, чтобы корректно преобразовывался в double
        double doseRate = str.toDouble();
        qDebug()<<"doseRate= "<<doseRate;
        double sens = 0;
        //0-Гр/с 1-мГр/с 2-Гр/ч 3-мГр/ч
        switch (currentIndex) {
        case 0: sens=std::abs(doseRate/I);break; // (Гр/с)/(Кл/с)=Гр/с
        case 1: sens=std::abs((1/(1E3))*doseRate/I);break; // (мГр/с)/(Кл/с)=Гр/с /(1000)
        case 2: sens=std::abs((1/(3.6E3))*doseRate/I);break; // (Гр/ч)/(Кл/с)=Гр/с  /(3600)
        case 3: sens=std::abs((1/(3.6E6))*doseRate/I);break; // (мГр/ч)/(Кл/с)=Гр/с /(3600000)
        default: break;
        }

        sensibility = QString::number(sens);
        qDebug() << "sensibility" << sensibility;
        emit sendSensibilityToQml(sensibility);
    }
}

void Beta_verify::timeOut() {
    //------------------------------------Время-------------------------------------------------------
    time++;
    emit sendTime(QString::number(time));
    //------------------------------------Мощность дозы-------------------------------------------------------
    I = betaChamber->getIres(); //считываем измерение из класса Beta_chamber в Гр/с
    //------------------------------------СКО и Среднее-------------------------------------------------------
    Isum+=I;
    avI=(Isum/time);// - средняя величина мощности дозы
    emit sendCurrentOrCountRateValue(QString::number(avI, 'g', 4));
    //double avDoseRate = dose*timeCoef;
    otkl+=I*I; //сумма квадратов случайной величины
    if(time>0) {
        double z=sqrt((otkl/time)-avI*avI); //CKO по хитрой формуле: корень из D=(1/N)SUM(1,N,Xi^2)-M^2
        // формула получена на основании того что СКО - это корень из дисперсии
        // Дисперсия - математическое ожидание квадрата отклонения случайной величины от её математического ожидания
        // D=M[X-M(X)]^2 = M(X^2) - M^2(X); - особенное свойство которое везде доказывается
        // M(X^2) - для равновероятных событий является = (1/N)SUM(1,N,doseRate*doseRate)
        // Дисперсия равняется мат ожиданию квадрата случайной величины минус квадрат мат ожидания случайной величины
        // отсюда и получается данная формула: корень из D=(1/N)SUM(1,N,Xi^2)-(среднее)^2

        StandardDeviation=std::abs(z/avI); //под СКО подразумеваем СКО деленное на среднее и умножить на 100% (относительное отклонение от среднего)
        sendStandardDeviation(QString::number(StandardDeviation, 'g', 4));
    }
}
