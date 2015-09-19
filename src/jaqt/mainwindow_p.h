#ifndef MAINWINDOW_P__H
#define MAINWINDOW_P__H

#include <QObject>
#include <QList>
#include <QHelpEngine>
#include "settings/AppSettings.h"

class DocumentManager;
class MainWindow;
class DocumentManagerModel;
class QAction;


class MainWindowPrivate : public QObject
{
    Q_OBJECT
public:
    MainWindowPrivate(QObject *parent);
    ~MainWindowPrivate();

    DocumentManager *docManager_;
    DocumentManagerModel *docManagerModel_;
	QHelpEngine *helpEngine_; 

    //Recent documents
    void AppendRecentDocument(const QString &filename);
    void removeRecentDocuments();
    inline const QList<QAction*> RecentDocuments() { return recentDocuments_;}


signals:
    void RecentDocumentsChanged(const QList<QAction*> &);


private:
    QList<QAction*> recentDocuments_;

};
#endif
