#ifndef SETTINGS_ELECTROMETER_H
#define SETTINGS_ELECTROMETER_H

#include "engine.h"

#include <QObject>

class Settings_electrometer : public QObject
{
    Q_OBJECT
public:
    explicit Settings_electrometer();
    ~Settings_electrometer();
signals:
    void sendInitValues(const QString& periodRS232,
                        const QString& R1,
                        const QString& referenceVoltage,
                        const QString& heatingTime,
                        const QString& changeTimeout,
                        const QString& testTimeout,
                        const QString& countsAver,
                        const QString& minDAC,
                        const QString& maxDAC,
                        const QString& minRefVolt,
                        const QString& maxRefVolt,
                        const QString& minR2,
                        const QString& maxR2,
                        const QString& minR3,
                        const QString& maxR3,
                        const QString& minI,
                        const QString& maxI);
public slots:
    void init();
    void onOkButton();
    void onBackButton();
    void onPeriodRS232(const QString& s);
    void onR1(const QString& s);
    void onReferenceVoltage(const QString& s);
    void onHeatingTime(const QString& s);
    void onChangeTimeout(const QString& s);
    void onTestTimeout(const QString& s);
    void onCountsAver(const QString& s);
    void onMinDAC(const QString& s);
    void onMaxDAC(const QString& s);
    void onMinRefVolt(const QString& s);
    void onMaxRefVolt(const QString& s);
    void onMinR2(const QString& s);
    void onMaxR2(const QString& s);
    void onMinR3(const QString& s);
    void onMaxR3(const QString& s);
    void onMinI(const QString& s);
    void onMaxI(const QString& s);

private slots:
    void on_pushButton_3_clicked();


private:
    QQmlApplicationEngine* this_engine;
    std::unique_ptr<QString> periodRS232 = std::make_unique<QString>();
    std::unique_ptr<QString> R1 = std::make_unique<QString>();
    std::unique_ptr<QString> referenceVoltage = std::make_unique<QString>();
    std::unique_ptr<QString> heatingTime = std::make_unique<QString>();
    std::unique_ptr<QString> changeTimeout = std::make_unique<QString>();
    std::unique_ptr<QString> testTimeout = std::make_unique<QString>();
    std::unique_ptr<QString> countsAver = std::make_unique<QString>();
    std::unique_ptr<QString> minDAC = std::make_unique<QString>();
    std::unique_ptr<QString> maxDAC = std::make_unique<QString>();
    std::unique_ptr<QString> minRefVolt = std::make_unique<QString>();
    std::unique_ptr<QString> maxRefVolt = std::make_unique<QString>();
    std::unique_ptr<QString> minR2 = std::make_unique<QString>();
    std::unique_ptr<QString> maxR2 = std::make_unique<QString>();
    std::unique_ptr<QString> minR3 = std::make_unique<QString>();
    std::unique_ptr<QString> maxR3 = std::make_unique<QString>();
    std::unique_ptr<QString> minI = std::make_unique<QString>();
    std::unique_ptr<QString> maxI = std::make_unique<QString>();
};

#endif // SETTINGS_ELECTROMETER_H
