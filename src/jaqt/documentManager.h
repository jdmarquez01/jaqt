#ifndef DOCUMENTMANAGER_H
#define DOCUMENTMANAGER_H
#include <QObject>
#include <QList>
#include "abstractdocument.h"


class DocumentManager : public QObject
{
    Q_OBJECT

  public:
    DocumentManager(QObject *parent = 0);
    virtual ~DocumentManager();

  public slots:
	void createDocument();
	void addDocument(QString);
    void addDocument(IDocument *document);
    void closeDocument( IDocument *document);
    void closeDocuments( const QList<IDocument*>& documents );
    void closeAll();
    void closeAllOther( IDocument* document );
    void requestFocus( IDocument* document );
    void setActiveDocument (IDocument *document);

  public:
    bool canClose( IDocument* document );
    bool canClose( const QList<IDocument*>& documents );
    bool canCloseAll();
    bool canCloseAllOther( IDocument* document );


    QList<IDocument *> documents() const;
    bool isEmpty() const;

    IDocument* activeDocument() const;




  public:
    //   DocumentCreateManager* createManager();
    //   DocumentSyncManager* syncManager();
    //   ModelCodecManager* codecManager();

  signals:
    // documents got added
    void added( IDocument* document );
    void closing(  IDocument* document );
    void activeDocumentChanged (IDocument *document);

    // void closing( KCloseEvent* event );
    // TODO: other than QObject event gets modified by observers, take care of unsetting a close cancel
    // problem with a signal is that all(!) observers get notified, even if event is already cancelled
    // better a visitor pattern?

    // TODO: or should the document be able to emit this?
    void focusRequested(IDocument* document );




  protected:
    QList<IDocument*> m_documents;
    IDocument *m_activeDocument;



  private slots:
    void on_activeDocumentChange(IDocument &document);


};

#endif // DOCUMENTMANAGER_H
