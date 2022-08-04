#ifndef RS485_H
#define RS485_H

#include <QThread>
#include <QObject>
#include <QtSerialPort/QSerialPort>
#include <QTimer>
#include <QDebug>

#include <QModbusClient>
#include <QModbusDevice>
#include <QModbusRtuSerialMaster>
#include <QModbusDataUnit>

#include <QMessageBox>

#include <qfloat16.h>
#include <QEventLoop>


class RS485:public QObject
{
    Q_OBJECT
public:
    explicit RS485(QObject* parent=nullptr);
    ~RS485();
    //QSerialPort *port;// = new QSerialPort(this);


    static bool BDGorBDKN; //BDG=0 BDKN=1

    void start();
    void stop();

    QModbusDataUnit readRequest() const;
    QModbusRequest readCommandRequest(uint8_t isotop) const;
    QModbusDataUnit writeRequest() const;
    float currentToropaSensibility = 0;
    void ReadCommand(uint8_t isotop);

    QTimer* tim;
signals:
    void signalData(float countRate);
    //qfloat16 signalQFloat(qfloat16);
    void errorSig();
    void sendCurrentSensibility(float sens);

public slots:
    void doWork();
    void endWork();

private slots:
    void timeOut();
    void error();           //ошибка соединения
    void onStateChanged(quint8);  //статус соединения

    void readyRead();
    void readyReadCommand();

private:
    void init();

    void ConnectPort();
    void DisconnectPort();
    void WriteToRegister();
    void ReadPort();


    void callError();


    QModbusClient *modbusDevice{nullptr};//QModbusClient QModbusRtuSerialMaster

    QTimer *timer{nullptr};
    //QTimer *timerDelay = new QTimer(this);//таймер задержки
    QMessageBox *msg{nullptr};


    quint8 SERVER_ADDRESS=0;// адрес сервера (MASTER)
    //int START_ADDRESS = 0;       // адрес регистра
    //int AMOUNT = 4;              // количество регистров

    quint16 START_ADDRESS = 0;       // адрес регистра скорости счета ТОРОПЫ
    quint8 AMOUNT = 0;              // количество регистров скорости счета ТОРОПЫ - 2 для float

    const int WRITE_SIZE = 1;    // количество перезаписываемых регистров

    const int BAUDS = 57600;
    const int STOP_BITS = 1;
    const int DATA_BITS = 8;
    //const QString PORT = "/dev/ttyDUMMY";
    const QString PORT = "/dev/ttyUSB0";
    const int PARITY = QSerialPort::NoParity;
    const int RESPONSE_TIME = 1000;

    static constexpr uint8_t address=1;
    static constexpr uint8_t commandNumber = 0x68;
    // для второго канала
    static constexpr uint16_t commandAttributesCo = 0x0005;
    static constexpr uint16_t commandAttributesCs = 0x0405;
    static constexpr uint16_t commandAttributesAm = 0x0805;
    QModbusRequest* request;
    QModbusReply *reply{nullptr};


    //Ответ на запрос одного параметра канала.
    //N    Значение               Размер, байт
    //1    Адрес 485              1
    //2    Команда (0x68)         1
    //3    Атрибуты команды       2
    //4    Длина массива данных   1
    //5    Параметр               2 [f16]
    //6    CRC-16                 2


    bool REQUEST_SENSIBILITY = false;
    QSerialPort* com;
    inline void delay(int millisecondsWait) {
        QEventLoop loop;
        QTimer t;
        t.connect(&t, &QTimer::timeout, &loop, &QEventLoop::quit);
        t.start(millisecondsWait);
        loop.exec();
    }

};
//bool RS485::BDGorBDKN=0;

#endif // RS485_H
