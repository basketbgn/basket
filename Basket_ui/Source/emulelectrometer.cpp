#include "emulelectrometer.h"

EmulElectrometer::EmulElectrometer()
{
    timer=new QTimer; //не пишем QTimer(this), т.к. все равно этот класс не наследуется от QWidget и надо все вызванное в динамической памяти удалять вручную
    connect(timer,&QTimer::timeout,this,&EmulElectrometer::timeOut); //коннект сигнала таймера на ф-ю timeOut()
}
EmulElectrometer::~EmulElectrometer() {
    delete timer; //удаляем таймер вручную
    qDebug()<<"~EmulElectrometer()";
}

//ф-я в которой происходит Эмуляция (простое увеличение смоделированного значения АЦП)
void EmulElectrometer::timeOut() {
    // переводит QString(273f4f5f6f7f) в массив символов char (2 7 3 f 4 f 5 f 6 f 7 f).
    const char *symbols = comString.toStdString().c_str();

    QString str{""};
    //каждый второй символ
    for (int j = 1; j < comString.length(); j += 2) {
        str.append(symbols[j]); //заполняем строку каждым вторым символом из comString
    }
    //iter = 1000;
    // переводит шестнадцатеричную строку в число long + его увеличение по таймеру;
    long numADC = str.toLong(nullptr, 16) + iter;
    iter++;
    // переводит число в шестнадцатиричную строку одной функцией, а не через самостоятельный цикл;
    QString B_16 = QString("%1").arg(numADC,0,16);
    //QString B_16=QString::number(numADC,16); //тоже самое, только по другому написано

    symbols = B_16.toStdString().c_str(); //снова в массив char-ов
    QString strB_16="";
    // преобразует 7ffffff в 273f4f5f6f7f
    for(int j=0;j<B_16.length();j++) {
        strB_16.append(QString::number(j+2));
        strB_16.append(symbols[j]);
    }
    sendString = strB_16;
    emit sendd(sendString); // посылаем строку далее (в AverageADC)
}

void EmulElectrometer::start()
{
    timer->start(100);  //таймаут каждые 100 мсек
}
void EmulElectrometer::stop()
{
    timer->stop();
}

//QString EmulElectrometer::getString() //не нужный метод get, не помню зачем написал, может для отладки???
//{
//    return sendString;
//}
