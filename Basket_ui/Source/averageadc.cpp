//********************* Класс который принимает данные АЦП или с СОМ порта или с эмулятора, усредняет и хранит****

#include "averageadc.h"

AverageADC::AverageADC() {
    init();
}

AverageADC::~AverageADC() {
    qDebug()<<"~AverageADC()";
    delete em;
    delete rs232;
}

void AverageADC::init() {
    // инициализация указателя (чтобы можно было бы потом удалить без падения программы далее делаем это при объявлении)
    em = nullptr;
    times = 10;
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db=QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr = "SELECT *FROM electrometer";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT table electrometer"<<query.lastError().text();}
        if(query.first()) {
            times = static_cast<uint8_t>(query.value("countsAver").toUInt()); // определяем число отсчетов при усреднении из настроек
        }
        //********************************************************************** определяем эмулятор или детектор
        qStr = "SELECT *FROM SourceChoice";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT table SourceChoice"<<query.lastError().text();}
        if(query.first()) {
            CurrSource = static_cast<bool>(query.value("emulator").toUInt());
        }
        //***********************************************************************
        db.close();
    }
    //если выбран эмулятор вызываем функцию emul()
    if(CurrSource == true) {
        emul();qDebug()<<"Emulator";
    }
    else { rs_232(); qDebug()<<"Detector RS-232";} //выбран реальный детектор
}

//прием сигнала со строкой из эмулятора (или реального электрометра) 2f3f4f5f6f7f
void AverageADC::recieveData(QString COM) {
    const char* charCOM = COM.toStdString().c_str();// - перевод строки в массив символов;
        QString strADC_Hex="";
        // - перевод массива символов в строку hex кода ADC; - ffffff
        for (int i=1;i<COM.length();i+=2) {
            strADC_Hex.append(charCOM[i]);
        }
        long numADC=strADC_Hex.toLong(nullptr,16); //-перевод строки в десятичное число; 0xffffff
        //qDebug()<<numADC;
        count++;
        avADC+=numADC;
        // каждые times раз вызываем усреднение
        if(count == times) {
            avADC = avADC/times; // усредняем показания
            callAverADC(avADC);//вызываем функцию в которой записываем усредненное значение в переменную
            count = 0;
            avADC = 0;
        }
}

void AverageADC::emul() {
    em = new EmulElectrometer; //создаем объект класса эмулятора электрометра
    connect(em,&EmulElectrometer::sendd,this,&AverageADC::recieveData); //коннект на прием сигнала из эмулятора
    em->start(); //запуск эмулятора
}

void AverageADC::rs_232() {
    rs232 = new RS232();
    connect(rs232,&RS232::outRS232,this,&AverageADC::recieveData);
}

//функция записи среднего значения в переменную averageADC
void AverageADC::callAverADC(long avADC) {
    averageADC = avADC;
//    if(averageADC != 8389607) {
//        averageADC = 8389607;
//    } else {
//        averageADC = 8389907;
//    }
}

//функция из которой можно узнать текущее усредненное показание АЦП
long AverageADC::getAverageADC() {
    return averageADC;
}

//слот приема сигнала о записи в СОМ порт
void AverageADC::sendToComSlot(QByteArray x) {
   qDebug()<<"<Будет записано в порт значение := "<<x.toHex();
    if(rs232!=nullptr) {
        rs232->writeToRS232(x);
    }
}

// HighVoltage
void AverageADC::sendToComSlot1(QByteArray volt) {
    quint32 DAC1=0;
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db=QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr =  "SELECT *FROM electrometerTest";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT table electrometerTest"<<query.lastError().text();}
        if(query.first()) {
            DAC1 = query.value("DAC").toUInt();
        }
    }
    QByteArray bytesDAC;
    bytesDAC.clear();
    QString strDAC=QString::number(DAC1,16);//переводим в шестнадцатеричный формат
    QString DAC4 = "", DAC5 = "", DAC6 = "";
    DAC4 = "4" + strDAC[0];
    DAC5 = "5" + strDAC[1];
    DAC6 = "6" + strDAC[2];
    bytesDAC.clear();
    bytesDAC.append(static_cast<char>(DAC4.toUInt(nullptr,16)));
    bytesDAC.append(static_cast<char>(DAC5.toUInt(nullptr,16)));
    bytesDAC.append(static_cast<char>(DAC6.toUInt(nullptr,16)));//записываем вычисленный массив байтов ЦАПа
    // посылаем массив байтов со значениями ЦАПа 4х5х6х для компенсации нуля усилителя
    bytesDAC.append(volt);
    qDebug()<<"<Будет записано в порт значение := "<<bytesDAC.toHex();
    if(rs232 != nullptr) {
        for(volatile long i=0; i<500000000;i++){}
        rs232->writeToRS232(bytesDAC);
        for(volatile long i=0; i<500000000;i++){}
        rs232->writeToRS232(bytesDAC);
        for(volatile long i=0; i<500000000;i++){}
        rs232->writeToRS232(bytesDAC);
    }
}
