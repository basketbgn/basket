#include "engine.h"
#include "main.h"
#include "mainwindow.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <QQuickView>
#include <QObject>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    Engine e;
    Engine::This_engine = &engine;    
    std::unique_ptr<MainWindow> mainWindow = std::make_unique<MainWindow>();

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
