#include "mainwindow.h"
#include "mainwindow_p.h"
#include "DocumentManager.h"
#include "DocumentManagerModel.h"

#include <QFile>
#include <QHelpEngine>
#include <algorithm>
#include <QAction>
#include <QTranslator>
#include <QApplication>
#include "settings/AppSettings.h"

MainWindowPrivate::MainWindowPrivate(QObject *parent) : QObject(parent)
{

  docManager_ = new DocumentManager();
  docManagerModel_ = new DocumentManagerModel(docManager_);


  //Load theme
  QIcon::setThemeName(AppSettings::Instance()[AppSettings::KEY_THEME].toString());




  //Load recent documents
  QStringList recentDocumentList = AppSettings::Instance()[AppSettings::KEY_RecentDocuments].toStringList();

  foreach(QString s, recentDocumentList)
    AppendRecentDocument(s);

}

void MainWindowPrivate::AppendRecentDocument(const QString &filename)
{
  if (filename.isEmpty()) return;

  QAction *action = new QAction(filename,this);


  recentDocuments_.prepend(action);
  QObject::connect(action, &QAction::triggered, [=]()
      {
            if (filename.isEmpty())
            {
              ;
            }
          });


  for (int i = qMin(recentDocuments_.count()-1,5); i >= 0 ;--i)
    recentDocuments_[i]->setShortcut(QKeySequence::fromString(QString("Ctrl+%1").arg(i+1)));
  if (recentDocuments_.count()>5)
      recentDocuments_[5]->setShortcut(QKeySequence());

  emit(RecentDocumentsChanged(recentDocuments_));

}

void MainWindowPrivate::removeRecentDocuments()
{
    recentDocuments_.clear();
    emit(RecentDocumentsChanged(recentDocuments_));
}


MainWindowPrivate::~MainWindowPrivate()
{
  delete docManagerModel_;
  delete docManager_;

}
