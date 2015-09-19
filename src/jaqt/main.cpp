#include "mainwindow.h"
#include <QApplication>
#include <QTranslator>
#include "settings/AppSettings.h"


int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    //Load localization
    QTranslator myappTranslator;
    bool ok =
    myappTranslator.load(AppSettings::Instance()[AppSettings::KEY_LANGUAGE].toString());
    QApplication::instance()->installTranslator(&myappTranslator);

    MainWindow w;
    w.show();

    return a.exec();
}
