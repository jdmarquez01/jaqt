#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "mainwindow_p.h"
#include "DocumentManager.h"
#include "DocumentManagerModel.h"

#include <QFile>
#include <algorithm>

#include "widgets/AboutDialog.h"
#include "settings/AppSettings.h"
#include "helpbrowser.h"
#include <QTabWidget>
#include <QHelpContentWidget>
#include <QHelpIndexWidget>
#include <QSplitter>
#include <QDockWidget>



//###############################################

MainWindow::MainWindow(QWidget *parent) :
  QMainWindow(parent),
  ui(new Ui::MainWindow),d_ptr(new MainWindowPrivate(this))
{
  ui->setupUi(this);
  ui->documentList->setModel(d_func()->docManagerModel_);
  ui->documentList->addAction(ui->actionOpen);




  AboutDialog *about = new AboutDialog(parent);
  connect(ui->actionAbout,&QAction::triggered,about,&AboutDialog::show,Qt::AutoConnection);

  connect(d_func(),&MainWindowPrivate::RecentDocumentsChanged,this,&MainWindow::UpdateRecentDocumentList);

  UpdateRecentDocumentList(d_ptr->RecentDocuments());





}

MainWindow::~MainWindow()
{

  AppSettings::Instance().writeSettings();

  delete ui;
}

void MainWindow::on_actionNew_triggered()
{

   static int i = 0;
  d_func()->docManager_->createDocument();
  d_func()->AppendRecentDocument(QString("%1").arg(i++));
}

void MainWindow::on_actionOpen_triggered()
{
  //d_func()->docManager_->();
}

void MainWindow::on_actionClear_Recent_triggered()
{
   d_ptr->removeRecentDocuments();

}

void MainWindow::on_actionSave_triggered()
{

}

void MainWindow::on_actionSave_as_triggered()
{

}



void MainWindow::on_documentList_activated(QModelIndex i)
{
  if (i.isValid())
    d_ptr->docManager_->setActiveDocument(i.data(Qt::UserRole + 1).value< IDocument*>());
}


void MainWindow::on_documentList_customContextMenuRequested(const QPoint  &pos)
{

  QMenu *menu = new QMenu(this);
  menu->addAction(new QAction("Header Action 1", this));
  menu->addAction(new QAction("Header Action 2", this));
  menu->addAction(new QAction("Header Action 3", this));
  menu->popup(ui->documentList->viewport()->mapToGlobal(pos));

}

void MainWindow::UpdateRecentDocumentList(const QList<QAction *> files)
{
    for (int i = ui->menuOpen_Recent->actions().count() - 1; i > 1; --i)
         ui->menuOpen_Recent->removeAction(ui->menuOpen_Recent->actions()[i]);
    ui->menuOpen_Recent->addActions(files);
}


void MainWindow::createHelpWindow(){
    QHelpEngine* helpEngine = new QHelpEngine(
                "doc/jaqt.qhc");


	//HelpEngineWrapper::instance("doc/guiExample2.qhc");

   bool ok =  helpEngine->setupData();

 
   //bool res = helpEngine->registerDocumentation("guiExample2.qch");

   QStringList sl = helpEngine->registeredDocumentations();

    QTabWidget* tWidget = new QTabWidget();
    tWidget->setMaximumWidth(200);
    tWidget->addTab(helpEngine->contentWidget(),"Contents");
    tWidget->addTab(helpEngine->indexWidget(),"Index");

   HelpBrowser *textViewer = new HelpBrowser(helpEngine);
	//HelpViewer *textViewer = new HelpViewer(100);
   /* textViewer->setSource(
                QUrl("qthelp://walletfox.qt.helpexample/doc/index.html"));*/
	connect(helpEngine->contentWidget(),
            &QHelpContentWidget::linkActivated,
			textViewer, &HelpBrowser::setSource);

	connect(helpEngine->indexWidget(),
            &QHelpIndexWidget::linkActivated,
			textViewer, &HelpBrowser::setSource);

    QSplitter *horizSplitter = new QSplitter(Qt::Horizontal);
    horizSplitter->insertWidget(0, tWidget);
    horizSplitter->insertWidget(1, textViewer);
    horizSplitter->hide();


    QDockWidget* helpWindow = new QDockWidget(tr("Help"), this);
    helpWindow->setWidget(horizSplitter);
    helpWindow->hide();
    addDockWidget(Qt::BottomDockWidgetArea, helpWindow);
	helpWindow->show();
}


void MainWindow::on_actionIndex_triggered()
{
 createHelpWindow();
}



void MainWindow::on_actionAbout_triggered()
{

}

void MainWindow::on_actionPreferences_triggered()
{

}

void MainWindow::on_actionCut_triggered()
{

}

void MainWindow::on_actionCopy_triggered()
{

}

void MainWindow::on_actionPaste_triggered()
{

}

void MainWindow::on_actionDelete_triggered()
{

}

void MainWindow::on_actionSelect_All_triggered()
{

}

void MainWindow::on_actionContent_triggered()
{
	
}

void MainWindow::on_actionQuit_triggered()
{

}



void MainWindow::on_actionUndo_triggered()
{

}

void MainWindow::on_actionRedo_triggered()
{

}

void MainWindow::on_actionClose_triggered()
{

}

void MainWindow::on_actionPrint_triggered()
{

}

void MainWindow::on_actionSave_Image_triggered()
{

}

