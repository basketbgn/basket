#include "mainwindow.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QQuickView>
#include <QObject>

#include <QDebug>
#include <map>


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    //const QUrl url(QStringLiteral("qrc:/main.qml"));
//    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
//                     &app, [url](QObject *obj, const QUrl &objUrl) {
//        if (!obj && url == objUrl)
//            QCoreApplication::exit(-1);
//    }, Qt::QueuedConnection);
    //engine.load(url);



//    QObject *info =
//       qobject_cast<QObject *>(engine.rootObjects().value(0));


//    static std::map<QString, QObject*> qml;
//    qml.emplace("MainPage.qml", main_qml);
//    qml.emplace("Beta.qml", beta_qml);

    std::unique_ptr<MainWindow> mainWindow = std::make_unique<MainWindow>(&engine);
    
    return app.exec();
}
