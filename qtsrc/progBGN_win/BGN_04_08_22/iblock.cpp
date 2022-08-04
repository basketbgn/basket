//*********************** полу абстрактный класс реализует корректировку скорости счета в зависимости от давления и температуры ********
#include "iblock.h"

Iblock::Iblock(float temp,float p, float corrF):
    Temp(temp),P(p),CorrF(corrF)
{
    init();
    //P=1;
}
Iblock::~Iblock()
{
    qDebug()<<"~Iblock()";
    timer->stop();
    qDebug()<<"timer->stop();";
    delete timer;
    qDebug()<<"delete timer;";
    delete averageMod;
    qDebug()<<"delete averageMod;";
}



void Iblock::init()
{
    averageMod = new AverageModbus;
    connect(averageMod,&AverageModbus::errorSig,this,&Iblock::errorSlot);
    timer = new QTimer;
    connect(timer,&QTimer::timeout,this,&Iblock::timeOut);

    if(QSqlDatabase::contains("myDB"))
    {
        QSqlDatabase db=QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr= "SELECT * FROM backgroundgamma";
        if(!query.exec(qStr)){
            qDebug()<<"unable execute query SELECT from backgroundgamma";
        }
        if(query.first()) {
            backgroundCR = query.value("backgroundGamma").toFloat();
            qDebug()<<"AAA"<<backgroundCR;
        }
        db.close();
    }

    timer->start(500);    
}

void Iblock::timeOut() //раз в полсекунды рассчитываем значение скорректированной скорости счета
{
    account_CR();
}

void Iblock::account_CR()
{
    float CR = averageMod->getAvCR();
    IblockCR_Res = (CR*CorrF*760*((273+Temp)/(293*P))); //поправки на температуру и давление и корректирующий коэффициент
    IblockCR_ResGamma = ((CR - backgroundCR)*CorrF*760*((273+Temp)/(293*P))); //поправки на температуру и давление и корректирующий коэффициент
    qDebug()<<IblockCR_ResGamma;
}

void Iblock::errorSlot()
{
    emit errorSig();
}

void Iblock::readBdgSensivity(uint8_t isotop)
{
    averageMod->readBdgSensivity(isotop);
}

float Iblock::getCurrentToropaSensivity()
{
    return averageMod->getCurrentToropaSensivity();
}
