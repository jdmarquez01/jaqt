#include "AppSettings.h"
#include <QApplication>


AppSettings::AppSettings(QObject *parent) : QSettings(QSettings::IniFormat,QSettings::UserScope, QApplication::applicationName(), QApplication::applicationName(), parent),settingsPath(this->fileName())
{
    for (auto k : allKeys())
        map_[k] = value(k);

}

AppSettings::~AppSettings()
{
}

void AppSettings::readSettings()
{


}
void AppSettings::writeSettings()
{

  for (QVariantMap::iterator it = map_.begin(); it != map_.end(); ++it)
    setValue(it.key(), it.value());

  sync();
}

QVariant AppSettings::defaultValue(const QString &key) const
{
  return QVariant();
}

bool AppSettings::flagDestroyed = false;
AppSettings* AppSettings::instance = 0;

