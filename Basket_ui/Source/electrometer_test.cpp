#include "electrometer_test.h"

Electrometer_test::Electrometer_test(){
    this_engine = Engine::This_engine;
    this_engine->rootContext()->setContextProperty("_cppApi_ElectrometerTest", this);
}

Electrometer_test::~Electrometer_test() {
    //qDebug()<<"delete avADC";
    delete avADC;
    //qDebug()<<"delete msg";
    //qDebug()<<"delete timer";
    delete timer;
    //qDebug()<<"delete timerGetADC";
    delete timerGetADC;
    //qDebug()<<"delete elTestRes";
    //delete elTestRes;
}

void Electrometer_test::testSource(bool test) {
    test_source=test;
}


void Electrometer_test::init() {
    h00.resize(2);
    h00[0]=0x20; h00[1]=0x30;
    h21.resize(2);
    h21[0]=0x22; h21[1]=0x31;
    h29.resize(2);
    h29[0]=0x22; h29[1]=0x39;
    h15.resize(2);
    h15[0]=0x21; h15[1]=0x35;
    h03.resize(2);
    h03[0]=0x20; h03[1]=0x33;
    hC2.resize(2);
    hC2[0]=0x2C; hC2[1]=0x32;
    h82.resize(2);
    h82[0]=0x28; h82[1]=0x32;
    h90.resize(2);
    h90[0]=0x29; h90[1]=0x30;
    hA0.resize(2);
    hA0[0]=0x2A; hA0[1]=0x30;

    //проверка на эмулятор
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db = QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        QSqlQuery query(db);
        QString qStr = "SELECT *FROM SourceChoice";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT table SourceChoice"<<query.lastError().text();}
        if(query.first()) {
            CurrSource = static_cast<bool>(query.value("emulator").toUInt());
        }
        //***********************************************************************
        qStr = "SELECT * FROM electrometer";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT table electrometer"<<query.lastError().text();}
        if(query.first()) {
            heatingTime = quint8(query.value("heatingTime").toInt());
            timeoutTest = quint8(query.value("testTimeout").toInt());
            R1 = query.value("R1").toInt();
            //averCounts = query.value("countsAver").toInt();
            averCounts = 5;
        }
        db.close();
    }
    //если выбран эмулятор вызываем функцию emul()
    if(CurrSource==true) {
    }
    else { qDebug()<<"Включаем тест";} //выбран реальный детектор
    avADC = new AverageADC();
    connect(this,&Electrometer_test::sendToCom,avADC, &AverageADC::sendToComSlot);
    timerGetADC = new QTimer;
    connect(timerGetADC,&QTimer::timeout,this,&Electrometer_test::SlotGetADC);
    timerGetADC->start(500);
    timer = new QTimer;
    connect(timer,&QTimer::timeout,this,&Electrometer_test::timeOut);
    timer->start(1000);
    //averageADC=avADC->getAverageADC(); //0xffffff
    //ui->progressBar->setValue(0); //бегущую строку установим в ноль
}

void Electrometer_test::onClose() {
    emit sendTestPassed(errorFlag);
    delete this;
}

void Electrometer_test::delay(uint x) {
    for(volatile uint i = 0; i < x; i++);
}

//ф-я измерения параметров электрометра
void Electrometer_test::timeOut() {
    //qDebug()<<"time=" << time;
    time++; //увеличиваем время каждую секунду
    emit sendTime((QString::number(time)));
    if(CurrSource) {
        qDebug()<<"Emulator";
        errorFlag = true;
        emit sendTestPassedToQml(true);
        emit sendTestResult("Emulator test");
        timer->stop();
    }


    comCheck += std::abs(averageADC);
    //********************************************************** Основная функция **********************************
    //проверка на корректное соединение!!!!!!!!!
    if(time>=7&&time<9) {
        qDebug()<<comCheck;
        if(comCheck <= 10 || QString::number(comCheck, 'f', 1) == "nan") {
            sendHardwareFault();
            delete this;
            return;
            //нет инфы с детектора (или около 0 или nan)
            time = 0;
            //            msg=new QMessageBox(QMessageBox::Critical,"ОШИБКА","Нет информации с детектора, \n необходим ремонт!!!");
            //            msg->setStandardButtons(QMessageBox::Ok);
            //            msg->setButtonText(QMessageBox::Ok,"ОК");
            //            msg->show();
            timer->stop();// остановим таймер чтобы не считал далее
            //            if(msg->exec() == QMessageBox::Ok) {
            //                //emit closePortTest();
            //                //close();
            //                emit closeTestAll();
            //                close();
            //            }
            delete this;
        }
    }
    //*******************************************  Прогрев (прибор должен прийти в себя после вкючения [уйти накопившийся заряд и т.д])
    if(time < heatingTime) {
        emit procedureName("Прогрев");
    }
    if (time == heatingTime) {
        emit sendToCom(h21);
        delay(10000);
        emit sendToCom(h21);
    }
    //*************************************** Выставление кода ЦАП на усилителе, для нулевого входного смещения усилителя ***************
    if (time == heatingTime + timeoutTest) {
        //emit sendToCom(h00);
        delay(10000);
        emit sendToCom(h00);
        emit procedureName("Самотестирование");
        emit progressBarSetValue(0);
    }
    if (time == heatingTime + 2*timeoutTest) {
        emit procedureName("Определение напряжения смещения");
        emit sendToCom(h21);
        delay(10000);
        emit sendToCom(h21);
        emit progressBarSetValue(0);
    }
    if (time == heatingTime + 3*timeoutTest) {
        bytesDAC.clear();
        bytesDAC.append(0x40);
        bytesDAC.append(0x50);
        bytesDAC.append(0x60);
        emit sendToCom(bytesDAC);
        delay(10000);
        emit sendToCom(bytesDAC);
        progressBarSetValue(10);

    }
    if (time >= heatingTime + 4*timeoutTest && time <= heatingTime + 4*timeoutTest + averCounts)
    {
        progressBarSetValue(QString::number(20 + 5*(time - (heatingTime + 4*timeoutTest))));
        y += averageADC;

        if(time == heatingTime + 4*timeoutTest+averCounts) {
            l1 = y / (averCounts + 1); // зреднее значение АЦП в разрядах
            qDebug()<<"l1"<<l1;
            y=0;
        }
        // l1=QString::number(averADC_V).toLong();
    }
    if (time==heatingTime+5*timeoutTest+averCounts) {
        progressBarSetValue(50);
        bytesDAC.clear();
        bytesDAC.append(0x4f);
        bytesDAC.append(0x5f);
        bytesDAC.append(0x6f);
        emit sendToCom(bytesDAC);
        delay(10000);
        emit sendToCom(bytesDAC);
    }
    if (time >= heatingTime + 6*timeoutTest+averCounts && time <= heatingTime + 6*timeoutTest + 2*averCounts)
    {
        progressBarSetValue(QString::number(50+5*(time-(heatingTime+6*timeoutTest+averCounts))));
        y += averageADC;
        if(time == heatingTime + 6*timeoutTest+2*averCounts) {
            l2 = y / (averCounts + 1); // зреднее значение АЦП в разрядах
            qDebug()<<"l2"<<l2;
            y = 0;
        }
        //l2=QString::number(averADC_V).toLong();
    }
    if (time == heatingTime + 6*timeoutTest + 2*averCounts) {
        progressBarSetValue(80);
        qDebug() << ADC0 << l1 << l2;
        d = std::abs((static_cast<double>(ADC0)-static_cast<double>(l1))/(static_cast<double>(l2)-static_cast<double>(l1)));
        qDebug() << d;
        double DAC=0;
        DAC = 0xFFF*d;
        qDebug() << DAC;
        DAC1 = static_cast<uint>(DAC);        //окончательное значение ЦАП - необходимо записать в БД
        QString strDAC=QString::number(DAC1,16);//переводим в шестнадцатеричный формат
        QString DAC4="",DAC5="",DAC6="";
        DAC4="4"+strDAC[0];
        DAC5="5"+strDAC[1];
        DAC6="6"+strDAC[2];
        bytesDAC.clear();
        bytesDAC.append(static_cast<char>(DAC4.toUInt(nullptr,16)));
        bytesDAC.append(static_cast<char>(DAC5.toUInt(nullptr,16)));
        bytesDAC.append(static_cast<char>(DAC6.toUInt(nullptr,16)));//записываем вычисленный массив байтов ЦАПа
    }
    if (time == heatingTime + 6*timeoutTest + 2*averCounts) {
        emit sendToCom(bytesDAC);
        delay(10000);
        emit sendToCom(bytesDAC);
    }
    if (time >= heatingTime + 7*timeoutTest+2*averCounts && time <= heatingTime+7*timeoutTest+3*averCounts)
    {
        y += averageADC;
        qDebug()<<y;
        if(time == heatingTime + 7*timeoutTest + 3*averCounts) {
            ADC_offset = (y-ADC0)*0.0000003/(averCounts + 1); // cреднее значение АЦП в разрядах
            y = 0;
        }
    }
    //***************** Калибровка R2 **********************************************************************************
    if (time==heatingTime+7*timeoutTest+3*averCounts)
    {
        progressBarSetValue(0);
        procedureName("Калибровка R2");
        emit sendToCom(h29);
        delay(10000);
        emit sendToCom(h29);
    }
    if (time==heatingTime+8*timeoutTest+3*averCounts) {
        progressBarSetValue(20);
    }
    if (time >= heatingTime + 8*timeoutTest + 3*averCounts && time <= heatingTime + 8*timeoutTest + 4*averCounts) {
        progressBarSetValue(QString::number(20 + 10*(time - (heatingTime + 8*timeoutTest + 3*averCounts))));
        y += averageADC;
        if(time == heatingTime+8*timeoutTest+4*averCounts) {
            l1 = y/(averCounts + 1); // зреднее значение АЦП в разрядах
            R2 = ((ADC0*R1*1000000)/(l1 - ADC0) - 100000)/1000000;   // - калибровка R2, в МОм
            qDebug() << "R2" << R2;
            y = 0;
        }
    }
    //****************************** Калибровка R3 ***************************************************************
    if (time == heatingTime + 8*timeoutTest + 4*averCounts) {
        progressBarSetValue(0);
        procedureName("Калибровка R3");
        emit sendToCom(h15);
        delay(10000);
        emit sendToCom(h15);
    }
    if (time == heatingTime + 9*timeoutTest + 4*averCounts) {
        progressBarSetValue(20);
    }
    if (time >= heatingTime+9*timeoutTest+4*averCounts && time <= heatingTime+9*timeoutTest+5*averCounts) {
        progressBarSetValue(QString::number(20+10*(time-(heatingTime+9*timeoutTest+4*averCounts))));
        y += averageADC;
        if(time == heatingTime + 9*timeoutTest + 5*averCounts) {
            l1 = y/(averCounts + 1); // зреднее значение АЦП в разрядах
            R3 = ((ADC0*R2*1000000)/(l1 - ADC0) - 100000)/1000000000; // - калибровка R3, в ГОм
            qDebug() << "R3" << R3;
            y = 0;
        }
    }
    //*************************************** Измерение тока ********************************************
    if (time == heatingTime + 9*timeoutTest + 5*averCounts) {
        progressBarSetValue(0);
        procedureName("Входной ток");
        emit sendToCom(h03);
        delay(10000);
        emit sendToCom(h03);// К1+К9
    }
    if (time == heatingTime + 10*timeoutTest + 5*averCounts) {
        progressBarSetValue(5);
        procedureName("Входной ток");
    }
    if (time == heatingTime+11*timeoutTest+5*averCounts) {
        progressBarSetValue(15);
    }
    if (time == heatingTime+12*timeoutTest+5*averCounts) {
        progressBarSetValue(17);
    }
    if (time == heatingTime+13*timeoutTest+5*averCounts) {
        progressBarSetValue(20);
    }
    if (time == heatingTime+14*timeoutTest+5*averCounts) {
        progressBarSetValue(25);
    }
    if (time == heatingTime+15*timeoutTest+5*averCounts) {
        progressBarSetValue(30);
    }
    if (time >= heatingTime+15*timeoutTest+5*averCounts && time <= heatingTime+15*timeoutTest+6*averCounts) {
        progressBarSetValue(QString::number(40 + 10*(time - (heatingTime + 15*timeoutTest + 5*averCounts))));
        y += averageADC;
        if(time == heatingTime + 15*timeoutTest+6*averCounts) {
            l1 = y/(averCounts + 1); // зреднее значение АЦП в разрядах
            U_Ioff = (l1 - ADC0);
            qDebug() << "U_Ioff= " << U_Ioff;
            I = (U_Ioff*0.0000003*1e-9)/R3;
            qDebug()<<"I"<<I;
            y = 0;
            if(QSqlDatabase::contains("myDB")) {
                QSqlDatabase db=QSqlDatabase::database("myDB");
                db.setDatabaseName("config.db");
                if(!db.open()){qDebug()<<"db was not opened";}
                QSqlQuery query(db);
                //************************************************
                QString qStr="UPDATE electrometerTest SET DAC='%1'";
                QString qStr1 = qStr.arg(QString::number(DAC1));
                if(!query.exec(qStr1)){qDebug()<<"unable execute query update electrometerTest"<<query.lastError().text();}
                //************************************************
                qStr="UPDATE electrometerTest SET Uoff='%1'";
                qStr1 = qStr.arg(QString::number(ADC_offset));
                if(!query.exec(qStr1)){qDebug()<<"unable execute query update electrometerTest"<<query.lastError().text();}
                //************************************************
                qStr="UPDATE electrometerTest SET R2='%1'";
                qStr1 = qStr.arg(QString::number(R2));
                if(!query.exec(qStr1)){qDebug()<<"unable execute query update electrometerTest"<<query.lastError().text();}
                //************************************************
                qStr="UPDATE electrometerTest SET R3='%1'";
                qStr1 = qStr.arg(QString::number(R3));
                if(!query.exec(qStr1)){qDebug()<<"unable execute query update electrometerTest"<<query.lastError().text();}
                qStr="UPDATE electrometerTest SET Iin='%1'";
                qStr1 = qStr.arg(QString::number(U_Ioff));
                if(!query.exec(qStr1)){qDebug()<<"unable execute query update electrometerTest"<<query.lastError().text();}
                db.close();
            }
            progressBarSetValue(100);
            //emit testEnd();

            //            elTestRes=new Electrometer_test_result(this);
            //            elTestRes->setModal(true);
            //            elTestRes->show();
            //            connect(elTestRes,&Electrometer_test_result::onCloseSig,this,&Electrometer_test::onCloseSlot);
            //            connect(elTestRes,&Electrometer_test_result::testOkSig,this,&Electrometer_test::testOkSlot);
            QString str = testResult();
            qDebug() << str;
            emit sendTestResult(str);
            emit sendTestPassedToQml(true);
//            if(!errorFlag) {
//                emit sendTestPassed(true);
//            } else {
//                emit sendTestPassed(false);
//            }
            //close();
            //delete this;
        }
    }
}

void Electrometer_test::SlotGetADC()
{
    averageADC = avADC->getAverageADC();
    ADC_V = (averageADC - ADC0)*0.0000003;
    emit sendADC(QString::number(averageADC, 10));
    emit sendADC_V(QString::number(ADC_V, 'g', 10));
    //ui->label->setText(QString::number(averageADC,10));
    //ui->label_3->setText(QString::number(ADC_V,'g',7));
}

QString Electrometer_test::testResult() {
    QString result{""};
    if(QSqlDatabase::contains("myDB")) {
        QSqlDatabase db=QSqlDatabase::database("myDB");
        db.setDatabaseName("config.db");
        if(!db.open()){qDebug()<<"db was not opened";}
        QSqlQuery query(db);
        QString qStr = "SELECT *FROM electrometer";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT table electrometer"<<query.lastError().text();}
        if(query.first()) {
            result = query.value("R1").toString() + "\n";
            //ui->lineEdit->setText(query.value("R1").toString()); //заполняем первый lineEdit
        }
        qStr = "CREATE TABLE IF NOT EXISTS electrometerTest  (id INTEGER PRIMARY KEY CHECK (id=0),"   //таблица из одной строки
                "Uoff TEXT(10),"
                                                                 "DAC TEXT(10),"
                                                                 "R1 TEXT(10),"
                                                                 "R2 TEXT(10),"
                                                                 "R3 TEXT(10),"
                                                                 "Iin TEXT(10))";
        if(!query.exec(qStr)){qDebug()<<"unable execute query CREATE table electrometerTest"<<query.lastError().text();}
        //if(!query.exec("DROP TABLE electrometerTest")){qDebug()<<"unable execute query DELETE table electrometerTest"<<query.lastError().text();}
        qStr = "SELECT *FROM electrometerTest";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT from table electrometerTest"<<query.lastError().text();}
        if(query.first())
        {
            R3 = query.value("R3").toDouble();
            R2 = query.value("R2").toDouble();
            DAC1 = query.value("DAC").toDouble();
            RefVolt = query.value("Uoff").toDouble();
            int ADC=query.value("Iin").toInt();
            I = (ADC*0.0000003/(R3*1E9))*10E12;    //в пА;   (В/Ом=А *10^12 => пА)
            qDebug()<<ADC<<I<<R3;
            result.append("Uoff, мкВ=" + query.value("Uoff").toString() + "\n");
            result.append("ЦАП, =" + query.value("DAC").toString() + "\n");
            result.append("R1, Ом =" + query.value("R1").toString() + "\n");
            result.append("R2, Ом =" + query.value("R2").toString() + "\n");
            result.append("R3, Ом =" + query.value("R3").toString() + "\n");
            result.append("Ток утечки, А =" + QString::number(I,'g',4) + "\n");
        }
        qStr="SELECT *FROM electrometer";
        if(!query.exec(qStr)){qDebug()<<"unable execute query SELECT from table electrometer"<<query.lastError().text();}
        if(query.first()) {
            double minDAC = query.value("minDAC").toDouble();
            double maxDAC = query.value("maxDAC").toDouble();
            double minRefVolt = query.value("minRefVolt").toDouble();
            double maxRefVolt = query.value("maxRefVolt").toDouble();
            double minR2 = query.value("minR2").toDouble();
            double maxR2= query.value("maxR2").toDouble();
            double minR3 = query.value("minR3").toDouble();
            double maxR3 = query.value("maxR3").toDouble();
            double minI = query.value("minI").toDouble();
            double maxI = query.value("maxI").toDouble();
            //bool errorFlag=false;
            result.append("\n");
            if(RefVolt < minRefVolt || RefVolt > maxRefVolt) {
                errorFlag=true;
                result.append("показания напряжения смещения усилителя вышли за пределы\n");
            }
            if(DAC1 < minDAC || DAC1 > maxDAC) {
                errorFlag=true;
                result.append("показания ЦАП вышли за пределы\n");
            }
            if(R2 < minR2 || R2 > maxR2) {
                errorFlag=true;
                result.append("показания R2 вышли за пределы\n");
            }
            if(R3 < minR3 || R3 > maxR3) {
                errorFlag=true;
                result.append("показания R3 вышли за пределы\n");
            }
            if(I < minI || I > maxI) {
                errorFlag=true;
                result.append("показания входного тока вышли за пределы\n");
            }
            if (errorFlag){
                result.append("Тест не пройден\n");
            }
        }
        db.close();
    }
    return result;
}

void Electrometer_test::on_pushButton_clicked() //отмена
{
    if(test_source) {
        //если тест был открыт из окна измерения
        if(testOk) {
            //если тест пройден
            close();
        }
        else {
            emit close();
            emit closeTestAll(); //посылаем сигнал закрыть другое окно
        }
    }
    else {
        // если тест был вызван просто
        emit close();
    }
}
//прием сигнала о закрытии окна
void Electrometer_test::onCloseSlot() {
    //если тест был открыт из окна измерения
    if(test_source) {
        if(testOk) {
            //если тест пройден
            close();
        }
        else {
            emit close();
            emit closeTestAll(); //посылаем сигнал закрыть другое окно
        }
    }
    else {
        // если тест был вызван просто
        emit close();
    }
}

void Electrometer_test::testOkSlot() {
    testOk = true;
}

void Electrometer_test::onCancelButton() {
    sendTestPassed(errorFlag);
    delete this;
}
