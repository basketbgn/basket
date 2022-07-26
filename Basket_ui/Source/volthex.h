#ifndef VOLTHEX_H
#define VOLTHEX_H

#include <QObject>
#include <QDebug>

#include "math.h"


class voltHex: public QObject
{
    Q_OBJECT
public:
    voltHex();


//    void byteVolts(QByteArray);


QByteArray  intVolt(int);

};

#endif // VOLTHEX_H
