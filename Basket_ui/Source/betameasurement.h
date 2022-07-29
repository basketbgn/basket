#ifndef BETAMEASUREMENT_H
#define BETAMEASUREMENT_H

#include "beta_chamber.h"
#include "engine.h"
#include "abstract_measurement_measurement.h"

#include <QObject>
#include <QTimer>

class BetaMeasurement : public QObject, public Abstract_measurement_measurement
{
    Q_OBJECT
public:
    BetaMeasurement(const QString dimension="",const int dimensionForTime=0,
                    bool regime=0, const uint timesAutomatic=0,
                    const uint timeAutomatic=0, const uint8_t threashold=0,
                    const uint timeThreashold=0, const double doseThreashold=0);
    ~BetaMeasurement();
    void Beta(Beta_chamber* x);
signals:
    void sendTime(QVariant time);

    void sendStandardDeviation(const QString& sd);
    void sendDoseRate(const QString& doseRate);
    void sendDimension(const QString& dimension);
    void sendDose(const QString& dose);
    void sendDoseDimension(const QString& dimensionDose);
    void sendAverageDoseRate(const QString& avDR);
    void sendAverageDoseRateDimension(const QString& dimensionAverDoseRate);
    void sendAdditionalInfo(const QString& info);
    void sendMode(bool);
    void sendAutoResult(const QString& str);

public slots:
    void init();
    void onBackButton();
    void startPressed();
    void stopPressed();
private slots:
    void timeOut(); //основная функция измерения в данном классе, обновляющаяся каждую секунду    
private:
    //метод вызываемый в конце автоматического измерения (передаем в него среднюю мощность дозы, среднюю дозу, и их СКО)
    void autoModeResult(double,double,double,double) override;

    QQmlApplicationEngine* this_engine;
    Beta_chamber* beta{nullptr};                     //указатель на объект класса бета камеры из которого берем результат в Гр/с
    //QString chamberName;
    QTimer* timer;

    ulong time{0};
        double doseRate{0};
        // переменная являющаяся интегралом от мощности дозы (выводящаяся на экран) и обнуляющаяся при автоматическом измерении
        double dose{0};
};

#endif // BETAMEASUREMENT_H
