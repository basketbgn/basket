#include "mainwindow.h"
#include <QApplication>
#include <QFontDatabase>
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QFontDatabase::addApplicationFont("/usr/share/fonts/truetype/lato/Lato-Bolditalic.ttf");
    QFontDatabase db;
      for(int i=0; i<db.families().size(); i++)
      {
        qDebug() << db.families().at(i);
      }
    QString col="QWidget{color: white; background-color: rgb(223,239,255);}"

        "QPushButton{"
            //"font-size: 19px;"
            "font: 22pt  'Lato Bold';"
            "color: rgba(38, 22, 7, 0.9);"
            //"background-color: rgba(90,240,43, 0.9);"

            "background-color:qradialgradient(cx:0.5, cy:0.5, radius: 1,"
            "fx:0.5, fy:0.5, stop:0 rgba(120, 240, 62, 0.7), stop:1 rgba(90, 200, 50, 0.9));"
            "border:1px;border-radius:10px;"
            "border:solid grey;"
            "border-style: outset;"
            "border-width: 2px;"
            "border-color: (188, 198, 204, 100);"
            "padding: 4px;}"
        "QPushButton:pressed{border-radius:10px; background: qradialgradient(cx:0.5, cy:0.5, radius: 1,"
            "fx:0.5, fy:0.5, stop:0 rgba(220, 220, 0, 150), stop:1 rgba(250, 250, 250, 150));border:1px;"
            "border:solid grey;"
            "border-style: outset;"
            "border-width: 1px;"
            "border-color: (188, 198, 204, 200);"
            "padding: 4px;}"
        "QLineEdit{"
            "color:black; "
            "background-color:transparent;"
            "border:solid grey;"
            "border-style: outset;"
            "border-width: 1px;"
            " min-height:30px;"
            "font-size:28px;}"
        "QLabel{"
                " font-size:20px;"
                " color: rgba(90,55,29,0.9);"
                " background-color: transparent;}"
        "QListWidget{"
                " color: rgba(90,55,29,0.9);"
                " background-color: transparent; "
                "font-size:30px}"
        "QScrollBar::vertical{"
                "width: 40px}"
        "QRadioButton::indicator{"
                " color: rgba(90,55,29,0.9);"
                "width: 25px; height: 25px;}"
        "QRadioButton{"
                " color: rgba(90,55,29,0.9);"
                "font-size:24px;}"
        "QComboBox{"
                " color: rgba(90,55,29,0.9);"
                "height:27px;font-size:25px;}"
        "QCheckBox{"
                " color: rgba(90,55,29,0.9);"
                "height:25px;width:20px;font-size:25px;}"
        "QTextEdit{"
                " color: rgba(90,55,29,0.9);"
                "font-size:20px;}";

    a.setStyleSheet(col);

    MainWindow *w=new MainWindow();
    w->move(0,0);

    w->showFullScreen();                        //showFullScreen() сделаем в самом конце, иначе не видно консоль отладки

    return a.exec();
}
