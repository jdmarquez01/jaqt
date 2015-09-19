#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QScopedPointer>


namespace Ui {
class MainWindow;
}

class MainWindowPrivate;
class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();


protected:
  const QScopedPointer<MainWindowPrivate>  d_ptr;


  private slots:
  void on_actionNew_triggered();
  void on_actionOpen_triggered();
  void on_actionSave_triggered();
  void on_actionSave_as_triggered();


  void on_actionPrint_triggered();
  void on_actionSave_Image_triggered();
  void on_actionClose_triggered();
  void on_actionQuit_triggered();
  void on_actionClear_Recent_triggered();
  void on_actionUndo_triggered();
  void on_actionRedo_triggered();
  void on_actionCut_triggered();
  void on_actionCopy_triggered();
  void on_actionPaste_triggered();
  void on_actionDelete_triggered();
  void on_actionSelect_All_triggered();
  void on_actionContent_triggered();
  void on_actionIndex_triggered();
  void on_actionAbout_triggered();
  void on_actionPreferences_triggered();

  // documentList
  void on_documentList_activated(QModelIndex);
  void on_documentList_customContextMenuRequested(const QPoint&);
  //RecentDocuments

private slots:
  void UpdateRecentDocumentList(const QList<QAction*> files);
  void createHelpWindow();

private:
   Ui::MainWindow *ui;
   Q_DECLARE_PRIVATE(MainWindow)

};

#endif // MAINWINDOW_H
