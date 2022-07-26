#ifndef BETA_VERIFY_H
#define BETA_VERIFY_H

#include "engine.h"
#include "beta_chamber.h"

#include <cmath>
#include <QObject>
#include <QTimer>
#include <QEventLoop>
#include <QStringListModel>


class Beta_verify : public QObject
{
    Q_OBJECT

public:
    explicit Beta_verify();
    ~Beta_verify();

    void getBetaChamber(Beta_chamber* beta);
signals:
    void sendTime(const QString&);
    void sendCurrentOrCountRateValue(const QString&);
    void sendStandardDeviation(const QString&);
public slots:
    void init();
    void onBackButton();
    void startPressed();
    void stopPressed(const QString&);
    void onSaveButton();
private slots:
    void timeOut();
    void startTimeOut();


private:
    QQmlApplicationEngine* this_engine;
    Beta_chamber* betaChamber{nullptr};
    QTimer* timer{nullptr};
    QTimer* startTimer{nullptr};



    long time{0};
    double I{0};
    double Isum{0};
    double avI{0};
    double otkl{0};
    double StandardDeviation{0};
    QString chamberName{""};
    QStringList* comList{nullptr};
    QStringListModel* comModel{nullptr};
};

#endif // BETA_VERIFY_H
