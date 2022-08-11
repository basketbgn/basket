#include "rs485.h"
//#include "neutron_measuring.h"
//#include "gamma_bdg_measuring.h"

bool RS485::BDGorBDKN=0;

RS485::RS485(QObject* parent):QObject(parent)
{
    init();
}

RS485::~RS485()
{
    if(modbusDevice)
    {
        modbusDevice->disconnectDevice();
    }
    delete modbusDevice;
    delete timer;
    delete msg;
}

void RS485::init()
{    
    com = new QSerialPort(this);
    com->setPortName(PORT);
    com->setBaudRate(QSerialPort::Baud57600); //на такой скорости работает электрометр
    com->setDataBits(QSerialPort::Data8);
    com->setParity(QSerialPort::NoParity);
    com->setStopBits(QSerialPort::OneStop);
    com->setFlowControl(QSerialPort::NoFlowControl);
    tim = new QTimer;
    connect(tim, &QTimer::timeout,[&]{
        //int x = modbusDevice->device()->bytesAvailable();
       int x = com->bytesAvailable();
       //QByteArray arr = modbusDevice->device()->readAll();
       QByteArray arr = com->readAll();
       qDebug()<<x << "RESULT"<<arr;
       tim->stop();
       com->close();

       //TODO: get float sensibility and write it to current currrentToropaSensibility
       uint32_t intSens = (((arr.data()[5]&0xFF)<<8) + (arr.data()[6]&0xFF)) << 16;
       qDebug()<<QString::number(intSens,16);
       float floatSens = *reinterpret_cast<float*>(&intSens);
       qDebug()<<"int"<<QString::number(intSens,16) << " float" <<floatSens;
       // save to static variable (then it will be read called procedure)
       currentToropaSensibility = floatSens;
       delay(100);
       modbusDevice->connectDevice();
       timer->start(500);
    });
    if(!BDGorBDKN)
    {
        SERVER_ADDRESS = 0x08;
        //SERVER_ADDRESS = 0x1;
        //START_ADDRESS = 0x10d; //первый канал
        START_ADDRESS = 0x12d; //второй канал
        //START_ADDRESS = 0x14d; //третий канал

        AMOUNT = 1;
        qDebug()<<"Address of BDG";
    }
    else
    {
        SERVER_ADDRESS = 9;
        START_ADDRESS = 0x10d; // если второй канал (control)
        //START_ADDRESS = 0xdd; // если первый канал (measure)
        /*!< новая версия >*/
        //START_ADDRESS = 0x10d; //первый канал (measure)
        //START_ADDRESS = 0x12d; //второй канал (control)
        //START_ADDRESS = 0x14d; //третий канал

        AMOUNT = 1;
        qDebug()<<"Address of BDKN";
    }
    modbusDevice = new QModbusRtuSerialMaster(this); // создаем объект как мастер

    //connect(modbusDevice, &QModbusClient::errorOccurred, [this](QModbusDevice::Error){statusBar()->showMessage(modbusDevice->errorString(), 5000);});
    //ЛЯМБДА функция (локальная, где вызывается там и выполняется)  не будем ей пользоваться
    connect(modbusDevice,&QModbusClient::errorOccurred,this,&RS485::error); //сигнал по ошибке

    if(modbusDevice) //если создался объект
    {
        //connect(modbusDevice, &QModbusClient::stateChanged, this, &MainWindow::onStateChanged);
        connect(modbusDevice,&QModbusClient::stateChanged,this,&RS485::onStateChanged); //сигнал по изменению статуса
    }
    timer=new QTimer(this);
    connect(timer,&QTimer::timeout,this,&RS485::timeOut); //коннектим таймер
    ConnectPort();    
    request = new QModbusRequest;
    //reply = new QModbusReply();
}

void RS485::start()
{
    timer->start(500);
    modbusDevice->setTimeout(100);
    //ConnectPort();
}

void RS485::stop()
{
    timer->stop();
    DisconnectPort();
}

QModbusDataUnit RS485::readRequest() const  //запрос на чтение holding_registers (функция 03)
{
    qDebug()<<"START_ADDRESS "<<START_ADDRESS;
    return QModbusDataUnit(QModbusDataUnit::HoldingRegisters, START_ADDRESS, static_cast<quint16>(AMOUNT));
}

QModbusRequest RS485::readCommandRequest(uint8_t isotop) const
{
    qDebug()<<"START_ADDRESS "<<START_ADDRESS;
    auto cmd = QModbusPdu::FunctionCode(0x68);
    //QModbusPdu pdu;
    //auto cmd = commandNumber;
    QByteArray modbusCommand;
    if(isotop == 0) {
        modbusCommand.append(commandAttributesCo>>8);
        modbusCommand.append(commandAttributesCo & 0xFF);
    } else if (isotop == 1) {        
        modbusCommand.append(commandAttributesCs>>8);
        modbusCommand.append(commandAttributesCs & 0xFF);
    } else if(isotop == 2) {
        modbusCommand.append(commandAttributesAm>>8);
        modbusCommand.append(commandAttributesAm & 0xFF);
    }
    request->setFunctionCode(cmd); // QModbusRequest(cmd,modbusCommand);
    request->setData(modbusCommand);
    bool valid = request->isValid();
    return *request;
    //QModbusRequest(QModbusPdu::FunctionCode(commandNumber), QModbusRequest::WriteSingleRegister);
    //return QModbusDataUnit(QModbusDataUnit::RegisterType::DiscreteInputs, START_ADDRESS, static_cast<quint16>(AMOUNT));
}

QModbusDataUnit RS485::writeRequest() const  //запрос на запись holding_register (функция 06) пока не нужна
{
    return QModbusDataUnit(QModbusDataUnit::HoldingRegisters, START_ADDRESS,static_cast<quint16>(WRITE_SIZE));
}



void RS485::ConnectPort()
{
    qDebug()<<"ConnectPort";

    if (!modbusDevice) {return;}  //если нету указателя на объект то выход из метода

    if (modbusDevice->state() != QModbusDevice::ConnectedState)  //если не соединено устанавливаем соединение с параметрами:
    {
        modbusDevice->setConnectionParameter(QModbusDevice::SerialPortNameParameter, PORT);
        modbusDevice->setConnectionParameter(QModbusDevice::SerialParityParameter, PARITY);
        modbusDevice->setConnectionParameter(QModbusDevice::SerialBaudRateParameter, BAUDS);
        modbusDevice->setConnectionParameter(QModbusDevice::SerialDataBitsParameter, DATA_BITS);
        modbusDevice->setConnectionParameter(QModbusDevice::SerialStopBitsParameter, STOP_BITS);
        modbusDevice->setTimeout(RESPONSE_TIME);
        qDebug()<<PORT<<PARITY<<BAUDS<<DATA_BITS<<STOP_BITS;
        modbusDevice->setNumberOfRetries(0);        //повторные попытки соединения
        if (!modbusDevice->connectDevice())   // коннектимся (если не получилось выдаем ошибку с номером)
        {
            qDebug()<<modbusDevice->errorString();
        }
    }
    else                                        // если соединено, то разрываем соединение
    {
        modbusDevice->disconnectDevice();
    }

    //timer->start(500); //считываем каждые полсекунды
}

void RS485::DisconnectPort()
{    
    //timer->stop();  //останавливаем таймер, чтобы остановить запросы по RS-485
    modbusDevice->disconnectDevice();
}

void RS485::ReadPort() //метод считывания из порта
{
    if(REQUEST_SENSIBILITY) return;
    if (!modbusDevice)
    {return;}
    qDebug()<<"SERVER_ADDRESS"<<SERVER_ADDRESS;
    if (QModbusReply *lastRequest = modbusDevice->sendReadRequest(readRequest(), SERVER_ADDRESS)) //посылаем запрос чтения по таймеру
        //функция от наследника QModbusDevice:QModbusClient
        // если  существует lastRequest (ответ от модбаса по запросу чтения)
    {
        if (!lastRequest->isFinished())   //и если булевая функция isFinished==0
        {
            connect(lastRequest,&QModbusReply::finished,this,&RS485::readyRead); //создаем коннект на сигнал QModbusReply::finished о готовности к чтению
            //delete lastRequest;
        }
        else   delete lastRequest; // broadcast replies return immediately (широковещательный запрос возвращается немедленно)
    }
    else //(lastRequest==nullptr)
    {
       qDebug()<<"Read error: " + modbusDevice->errorString(); // если нет ответа от модбаса выводим ошибку
    }
}

void RS485::ReadCommand(uint8_t isotop)
{
    timer->stop();
    modbusDevice->disconnectDevice();
    delay(100);
    if(com->open(QIODevice::ReadWrite))
    {
        if(!com->isOpen())
        {
            qDebug()<<"error occured while opening port";
            com->close();
        }
        else
        {
            qDebug()<<"Port RS-232 to modbus is connected";
        }
    }
    reply = nullptr;
    QByteArray arr; arr.append(0x08); arr.append(0x68);
    if(isotop == 0) {
        arr.append(commandAttributesCo>>8); arr.append(commandAttributesCo & 0xFF);
        arr.append(0x43); arr.append(0x9b);
    } else if (isotop == 1) {
        arr.append(commandAttributesCs>>8); arr.append(commandAttributesCs & 0xFF);
        arr.append(0x41); arr.append(0x5b);
    } else if(isotop == 2) {
        arr.append(commandAttributesAm>>8); arr.append(commandAttributesAm & 0xFF);
        arr.append(0x44); arr.append(0x5b);
    }
    qDebug()<<"write to modbus"<<QString::number(arr.data()[0],16)
                               <<QString::number(arr.data()[1],16)
                               <<QString::number(arr.data()[2],16)
                               <<QString::number(arr.data()[3],16)
                               <<QString::number(arr.data()[4],16);
    com->write(arr);
    com->waitForBytesWritten(100000);
    com->clear();
    tim->start(100);
    return;
    ///////////////////////     MODBUS not working  /////////////////////////////////////
    //if (!modbusDevice)
    //{return;}
    //modbusDevice->disconnectDevice();
//    auto cmd = QModbusPdu::FunctionCode(0x68);
//    auto request = QModbusRequest(cmd, QByteArray::fromHex("0405"));
//    QModbusResponse response;
//    QModbusResponse::registerDataSizeCalculator(
//                    cmd,
//                    [](const QModbusResponse &)->int {
//            return 7;
//    });
//    auto reply = modbusDevice->sendRawRequest(request,0x08);
//    QThread::sleep(1);
//    response = reply->rawResult();
//    qDebug()<<"reply"<<response.data();

    //modbusDevice->processResponse(response,&unit);
    //connect(reply, &QModbusReply::finished, this, &RS485::readyReadCommand);
    //QString Data = "0405";
    //QByteArray pduData = QByteArray::fromHex(Data.toLatin1());
    //reply = modbusDevice->sendRawRequest(QModbusRequest(QModbusRequest::FunctionCode(0x68), pduData), 0x08);


    //QThread::sleep(1);
    //qDebug() << "Bytes:" << reply->result().values().data()[0];
    //connect(reply, &QModbusReply::finished, this, &RS485::readyReadCommand);//[=]() {
//        auto *lastRequest=static_cast<QModbusReply *>(sender()); //object_cast<> ~ static_cast
//        qDebug() << "Bytes:" << lastRequest->result().values().data()[0];
//        qDebug() << "Receive: Asynchronous response PDU: " << lastRequest->rawResult() << endl;
//        //QByteArray pduData = QByteArray::fromHex(Data.toLatin1());
//        QModbusReply *reply = nullptr;
//    });

    //qDebug()<<"SERVER_ADDRESS"<<SERVER_ADDRESS;
    //QModbusRequest request = readCommandRequest(isotop);
    //qDebug()<<"function"<<request.functionCode()<<"data"<<request.data();
    auto data = QByteArray(); data.append(0x04); data.append(0x05);
    if (QModbusReply *lastReq = modbusDevice->sendRawRequest(QModbusRequest(QModbusRequest::FunctionCode(0x68), data), 0x08))

                //QModbusReply *lastReq = modbusDevice->sendRawRequest(request, SERVER_ADDRESS)) //посылаем запрос чтения команды

        //функция от наследника QModbusDevice:QModbusClient
        // если  существует lastRequest (ответ от модбаса по запросу чтения)
    {
        if (!lastReq->isFinished())   //и если булевая функция isFinished==0
        {
            //modbusDevice->sendRawRequest(QModbusRequest(QModbusRequest::FunctionCode(0x68), data), 0x08);
            REQUEST_SENSIBILITY = true;
            //while(lastReq->finished())
            //connect(lastReq,&QModbusReply::finished,this,&RS485::readyReadCommand); //создаем коннект на сигнал QModbusReply::finished о готовности к чтению
            qDebug()<<"Connect on raw request";
            //delete lastRequest;
        }
        else   delete lastReq; // broadcast replies return immediately (широковещательный запрос возвращается немедленно)
    }
    else //(lastRequest==nullptr)
    {
       qDebug()<<"Read error: " + modbusDevice->errorString(); // если нет ответа от модбаса выводим ошибку
    }    
}

void RS485::readyRead() //сигнал в ответ на запрос чтения по таймеру
{
    //QModbusReply* lastRequest;
    auto *lastRequest=static_cast<QModbusReply *>(sender()); //object_cast<> ~ static_cast
    if (!lastRequest)
    {
        return;
    }

    if (lastRequest->error() == QModbusDevice::NoError)
    {
        //***********************************************************************************************************
        const QModbusDataUnit unit = lastRequest->result(); //записываем значения выдаваемое модбасом по запросу в класс контейнера
        quint16 f1=0;//,f2=0,f3=0,f4=0, h1=0;
        qDebug()<<unit.values();        
        //qfloat16 hf=0;
        uint32_t x=0;
        float z1=0;
        //float z2=0;
        //float z3=0;
        //float z4=0;
        f1=static_cast<quint16>(unit.value(0));//для эмулятора на STM32
        //f4=static_cast<quint16>(unit.value(15));//для эмулятора на STM32
        //qDebug()<<f1<<f2<<f3<<f4;
        //x=(f1<<16)|0x0;
        //z1=*reinterpret_cast<float*>(&x)*3600;
        //x=(f2<<16)|0x0;
        //z2=*reinterpret_cast<float*>(&x)*3600;
        x=(f1<<16)|0x0;
        z1=*reinterpret_cast<float*>(&x);
        //x=(f4<<16)|0x0;
        //z4=*reinterpret_cast<float*>(&x);
        //qDebug()<<z1<<z2<<z3<<z4;

        //h1=static_cast<quint16>(unit.value(3));//для эмулятора на STM32

        //qDebug()<<QString::number(f1,2)<<QString::number(f2,2)<<QString::number(h1,2);

        //void* h1_ptr = (void*)(&h1);
        //hf=*((qfloat16*)(h1_ptr));

        //x=static_cast<uint32_t>(f1<<16|f2); //объединяем два 16 битных регистра в один 32 битный.

        //void* v = static_cast< void* >( &x ); //сначала приводим к безтиповому указателю на void* (скинем тип указателя, чтобы принудительно не переводил int во float)
        //z = *static_cast< float* >( v ); // затем разыменовываем указатель на float* предварительно приведенный из типа указателя на float*

        emit signalData(z1); //посылаем скорость счета в формате float (В ТОМ ЧИСЛЕ ДЛЯ ТОРОПЫ)

        //emit signalData(z=hf); //посылаем скорость счета в формате float (предварительно переведя из half float)
        //qDebug()<<"float= "<<z<<" half float= "<<hf;

        //float xF = *reinterpret_cast<float*>(&v); //тоже самое но в одну строку, только получаем указатель переводим в float
        //qDebug()<<QString::number(y1,2)<<QString::number(y2,2);
        // qDebug()<<QString::number(x,2);

        for (uint i = 0; i < unit.valueCount(); i++)
        {
            const QString entry = tr("Address: %1, Value: %2").arg(unit.startAddress()+static_cast<int>(i))
                                     .arg(QString::number(unit.value(static_cast<int>(i))));
            //ui->readValue->addItem(entry); // добавляем значения в таблицу, которая выводится на экран
        }
        //float z=static_cast<float>(x); // так превращает int сразу во float (просто делает большое число, что есть полный бред)

        //************************************************************************************************************
    }
    else if (lastRequest->error() == QModbusDevice::ProtocolError)
    {
        QString str="Read response error: %1 (Mobus exception: 0x%2)";
        QString str2=str.arg(lastRequest->errorString()).arg(lastRequest->rawResult().exceptionCode());
        qDebug()<<str2<<" Protocol error";
    }
    else
    {
        QString str="Read response error: %1 (code: 0x%2)";
        QString str2=str.arg(lastRequest->errorString()).arg(lastRequest->rawResult().exceptionCode());
        qDebug()<<str2<<" Just error";
        qDebug()<<"Read error: " + modbusDevice->errorString();
        qDebug()<<lastRequest->error();
        qDebug()<<static_cast<quint16>(lastRequest->result().value(0));
        error();
    }
    lastRequest->deleteLater();
}

void RS485::readyReadCommand()
{
    REQUEST_SENSIBILITY = false;

    //! TODO: read raw request:
    auto *lastRequest=static_cast<QModbusReply *>(sender()); //object_cast<> ~ static_cast
    if (!lastRequest)
    {
        return;
    }
    QModbusResponse rep = lastRequest->rawResult();
    qDebug()<<"rep"<<rep;
    const QModbusDataUnit unit = lastRequest->result(); //записываем значения выдаваемое модбасом по запросу в класс контейнера
    qDebug()<<"readyReadCommand"<<lastRequest->error();
    if (lastRequest->error() == QModbusDevice::NoError)
    {
        //***********************************************************************************************************
        const QModbusDataUnit unit = lastRequest->result(); //записываем значения выдаваемое модбасом по запросу в класс контейнера
        qDebug()<<"Modbus raw reply";
        for(auto i: unit.values()) {
            qDebug()<< hex << i;
        }
        //TODO: get float sensibility and write it to current currrentToropaSensibility
    }
    //timer->start(500);
}

void RS485::WriteToRegister()
{
    //START_ADDRESS=;  //записываем в переменную адрес регистра для записи
    if (!modbusDevice)
    {return;}

    QModbusDataUnit writeUnit = writeRequest(); // объявляем объект класса контейнера QModbusDataUnit и выполняем запрос на запись
    //QModbusDataUnit::RegisterType table = writeUnit.registerType();
    //writeUnit.setValue(0, static_cast<quint16>(1));  //установим значение по указанному адресу

    if (QModbusReply *lastRequest = modbusDevice->sendWriteRequest(writeUnit, SERVER_ADDRESS)) //если существует такой запрос
    {
        if (!lastRequest->isFinished())
        {
            qDebug()<<writeUnit.value(0);
            if (lastRequest->error() == QModbusDevice::ProtocolError)
            {
                QString str="Write response error: %1 (Mobus exception: 0x%2)";
                QString str2=str.arg(lastRequest->errorString()).arg(lastRequest->rawResult().exceptionCode());
                qDebug()<<str2;
            }
            else if (lastRequest->error() != QModbusDevice::NoError)
            {
                QString str="Write response error: %1 (code: 0x%2)";
                QString str2=str.arg(lastRequest->errorString()).arg(lastRequest->rawResult().exceptionCode());
                qDebug()<<str2;
            }
        }
        else
            {
                // broadcast replies return immediately
                lastRequest->deleteLater();
            }
       //lastRequest->deleteLater();
    }
    else //если запрос не удался
    {
            qDebug()<<"Write error: " + modbusDevice->errorString();            
    }
}

void RS485::timeOut()
{
    ReadPort();
}

void RS485::error() //ошибка соединения
{
    timer->stop();
    //if(bdgPtr!=nullptr)
    //{
    //    //bdgPtr->
    //}
    //if(neutronPtr!=nullptr)
    //{
    //    //callback
    //}
    //
    //if(msg==nullptr)
    //{
    //    //emit error();
    //    //QMessageBox::warning(this, "Ошибка","Некорректный ввод");
    //
    //    //msg = new QMessageBox(QMessageBox::Information,"ERROR","Error",QMessageBox::Ok);
    //    //msg->setModal(false);
    //    //msg->show();
    //}
    //Gamma_BDG_measuring::errorConnection();
    qDebug()<<"ERROR connection";
    emit errorSig();
}


void RS485::onStateChanged(quint8 state) //статус соединения
{
    if (state == QModbusDevice::UnconnectedState)
    {qDebug()<<"disonnected";}
    else if (state == QModbusDevice::ConnectedState)
    {qDebug()<<"Connected";}
}

void RS485::doWork()
{
    start();
}

void RS485::endWork()
{
    stop();
}



