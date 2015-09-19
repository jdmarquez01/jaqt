#include <QLocale>

#include "defaultSettings.h"

defaultSettings::defaultSettings()
{
defaultValues_[KEY_LANGUAGE] = KEY_LANGUAGE_DEFAULT;
defaultValues_[KEY_THEME] = KEY_THEME_DEFAULT;
defaultValues_[KEY_RecentDocuments] = KEY_recentDocuments_DEFAULT;

}


const QString defaultSettings::KEY_LANGUAGE = "language";
const QString defaultSettings::KEY_LANGUAGE_DEFAULT =  QLocale::system().name();

const QString defaultSettings::KEY_THEME = "theme";
const QString defaultSettings::KEY_THEME_DEFAULT = "default";


const QString defaultSettings::KEY_RecentDocuments = "RecentDocuments";
const QString defaultSettings::KEY_recentDocuments_DEFAULT = "";
