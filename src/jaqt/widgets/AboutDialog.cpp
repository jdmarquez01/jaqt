#include "AboutDialog.h"
#include "ui_AboutDialog.h"
#include <QFile>
#include <QTextStream>



inline void LoadDocument(QPlainTextEdit *doc, const QString &filename)
{
    QFile f(filename);
    f.open(QIODevice::ReadOnly);
    QTextStream s(&f);
    doc->setPlainText(s.readAll());


}

AboutDialog::AboutDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::AboutDialog)
{
    ui->setupUi(this);

    LoadDocument(ui->readme, QStringLiteral(":/info/README.md"));
    LoadDocument(ui->changelog, QStringLiteral(":/info/CHANGELOG"));
    LoadDocument(ui->licence,QStringLiteral(":/info/LICENSE"));
    LoadDocument(ui->credits,QStringLiteral(":/info/CREDITS"));

}



AboutDialog::~AboutDialog()
{

}
