#ifndef BETA_VERIFY_H
#define BETA_VERIFY_H

#include "engine.h"
#include "beta_chamber.h"

#include <cmath>
#include <QObject>
#include <QTimer>
#include <QEventLoop>

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
    void sendListModel(const QStringList&);
    void sendSensibilityToQml(const QString& );
    void sendWarningMsg();
public slots:
    void init();
    void onBackButton();
    void startPressed();
    void stopPressed();
    void onSaveButton();
    void onSendDoseRate(const QString& str);
    void onSendCurrentIndex(const QString& i);

private slots:
    void timeOut();
    void startTimeOut();


private:
    QQmlApplicationEngine* this_engine;
    Beta_chamber* betaChamber{nullptr};
    QTimer* timer{nullptr};
    QTimer* startTimer{nullptr};
    uint8_t currentIndex{0};
    QString currentDoseRate{""};
    QString sensibility{""};

    long time{0};
    double I{0};
    double Isum{0};
    double avI{0};
    double otkl{0};
    double StandardDeviation{0};
    QString chamberName{""};
    QStringList* dimensionsList{nullptr};

    void sendSensibility();
};

#endif // BETA_VERIFY_H
