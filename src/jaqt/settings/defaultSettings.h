#ifndef DEFAULTSETTINGS__H_
#define DEFAULTSETTINGS__H_

#include <QString>
#include <QVariantMap>


//necesarios los accessors??
//#define ACCESSOR


class defaultSettings
{
public:

    defaultSettings();

    //[general]                                   ;
    static const QString KEY_LANGUAGE             ;
    static const QString KEY_LANGUAGE_DEFAULT     ;

    static const QString KEY_THEME                ;
    static const QString KEY_THEME_DEFAULT        ;

    static const QString KEY_RecentDocuments          ;
    static const QString KEY_recentDocuments_DEFAULT  ;



    QVariantMap defaultValues_;



};





#endif
