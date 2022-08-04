#ifndef NEUTRON_H
#define NEUTRON_H

#include "neutron_bdkn_test.h"
#include "neutron_measuring.h"
#include "block_bdkn.h"
#include <QDialog>

namespace Ui {
class Neutron;
}

class Neutron : public QDialog
{
    Q_OBJECT

public:
    explicit Neutron(QWidget *parent = nullptr);
    ~Neutron();

private slots:
    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

private:
    Ui::Neutron *ui;
    Neutron_BDKN_test * neutronTest{nullptr};
    void init();
};

#endif // NEUTRON_H
