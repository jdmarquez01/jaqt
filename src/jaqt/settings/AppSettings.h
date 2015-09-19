
#ifndef APPSETTINGS_H_
#define APPSETTINGS_H_

#include <QtCore/QSettings>
#include "settings/defaultSettings.h"


class AppSettings : public QSettings, public defaultSettings
{
public:

    static AppSettings& Instance()
    {
        if (!instance)
        {
            if (flagDestroyed)
                onDeadReference();
            else
                create();
        }

        return *instance;
    }





    void readSettings();
    void writeSettings();

    QVariant defaultValue(const QString &key) const;
    const QString settingsPath;

    inline QVariant& operator[](const QString &key)
    {

        if (!map_.contains(key))
        {
            map_[key] = defaultValues_[key];
        }
        return map_[key];
    }

private:

    static AppSettings* instance;
    static bool flagDestroyed;

    static void create()
    {
        static AppSettings localInstance;
        instance = &localInstance;
    }
    static void onDeadReference()
    {
        create();
        // now instance points to the "ashes" of the singleton
        // create a new singleton at that address
        new(instance) AppSettings;
        //atexit(kill);
        flagDestroyed = false;

    }
    void kill(void)
    {
        instance->~AppSettings();
    }

    AppSettings(QObject *parent = 0);
    ~AppSettings();

    QVariantMap map_;
};



#endif
