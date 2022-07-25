#ifndef BETAMEASUREMENTSETTINGS_H
#define BETAMEASUREMENTSETTINGS_H

#include "beta_chamber.h"
#include "betameasurement.h"
#include "engine.h"

#include <QObject>

class BetaMeasurementSettings : public QObject
{
    Q_OBJECT
public:
    BetaMeasurementSettings();
    ~BetaMeasurementSettings();
signals:
    void sendPassword(const QString&);
    void sendChambersList(const QStringList&);
    void transmitName(const QString&);
public slots:
    void init();
    void onBackButton();
    void onMeasurementButton(const QString& dimension,
                             const QString& dimensionForTime,
                             const QString& mode,
                             const QString& numberOFMeasurements,
                             const QString& timeOfOneMeasurement,
                             const QString& thresholds,
                             const QString& timeThreashold,
                             const QString& doseThreashold,

                             const QString& range,
                             bool controlCompensation,
                             const QString& temperature,
                             const QString& atmosphericPressureMercury,
                             const QString& correctionFactor,
                             const QString& chamberComboBoxName);
private:
    QQmlApplicationEngine* this_engine;
    Beta_chamber* betaChamber;
    BetaMeasurement* betaMes;
};

#endif // BETAMEASUREMENTSETTINGS_H
