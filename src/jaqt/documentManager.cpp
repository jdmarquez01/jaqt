#include "DocumentManager.h"

/*!
       \class DocumentManager
       \brief The QObject class is the base class of all Qt objects.
*/

/*!
 * \brief DocumentManager::DocumentManager
 * \param parent
 */
DocumentManager::DocumentManager(QObject *parent) : QObject(parent)
{
  ;
}
/*!
 * \brief DocumentManager::~DocumentManager
 */
DocumentManager::~DocumentManager() {}

static int i = 0;

/*!
 * \brief DocumentManager::createDocument
 */
void DocumentManager::createDocument()
{
	IDocument *d = new IDocument();
	d->setObjectName(QString("%1").arg(i++));
	addDocument(d);
	;
}

void DocumentManager::addDocument(QString cad)
{
	if (cad.isEmpty())
	{
		;
	}

}
void DocumentManager::addDocument( IDocument *document)
{

  if(!m_documents.contains(document))
  {
    m_documents.append(document);

    this->m_activeDocument = document;


    emit(added(document));
    emit(activeDocumentChanged(document));
  }
}

void DocumentManager::closeDocument( IDocument *document)
{
  if (document != NULL)
  {
    int i = m_documents.indexOf(document);

    if (i >= 0)
    {
      m_documents.removeAt(i);
      emit (closing(document));

      if (this->m_activeDocument == document)
      {
        this->m_activeDocument = m_documents.count() == 0 ? NULL :
                                                            i == 0 ? m_documents[0] :
                                                            m_documents[i-1];
        emit(activeDocumentChanged(this->m_activeDocument));
      }
      delete document;
    }
  }

}

void DocumentManager::closeDocuments(const QList<IDocument *> &documents)
{
  for (IDocument* d : documents)
    closeDocument(d);
}

void DocumentManager::closeAll()
{
  for (IDocument *d : m_documents)
  {
    emit(closing(d));
    delete d;
  }
  m_documents.clear();
  m_activeDocument = NULL;
  emit (activeDocumentChanged(NULL));
}

void DocumentManager::closeAllOther(IDocument *document)
{

}

void DocumentManager::requestFocus(IDocument *document)
{
  if (document != NULL)
  {
    int i = m_documents.indexOf(document);
    if (i >= 0)
    {
      m_activeDocument = m_documents[i];
      emit (activeDocumentChanged(m_activeDocument));
    }
  }
}

void DocumentManager::setActiveDocument(IDocument *document)
{
  if (document != m_activeDocument)
  {
    m_activeDocument = document;
    emit (activeDocumentChanged(m_activeDocument));
  }
}

bool DocumentManager::canClose(IDocument *document)
{
  return true;
}

bool DocumentManager::canClose(const QList<IDocument *> &documents)
{
  return true;
}

bool DocumentManager::canCloseAll()
{
  return true;
}

bool DocumentManager::canCloseAllOther(IDocument *document)
{
  return true;
}

QList<IDocument *> DocumentManager::documents() const
{
  return m_documents;
}

IDocument *DocumentManager::activeDocument() const
{
  return m_activeDocument;
}


void DocumentManager::on_activeDocumentChange(IDocument &document)
{
  if (&document != m_activeDocument)
  {
    m_activeDocument = &document;
    emit(activeDocumentChanged(this->m_activeDocument));
  }

}
