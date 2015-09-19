#include "DocumentManager.h"
#include "abstractdocument.h"
#include "DocumentManagerModel.h"


/*!
       \class DocumentManagerModel
       \brief The QObject class is the base class of all Qt objects.
*/

DocumentManagerModel::DocumentManagerModel(DocumentManager *manager) : m_manager(manager)
{

  connect(m_manager,&DocumentManager::added,this, &DocumentManagerModel::AddDocument);
  connect(m_manager,&DocumentManager::closing,this,&DocumentManagerModel::CloseDocument);

}

void DocumentManagerModel::AddDocument(IDocument *doc)
{
  if (doc != NULL)
  {
    int r = m_manager->documents().indexOf(doc);

    bool ok = this->insertRow(r);
    ;
  }
}

void DocumentManagerModel::CloseDocument(IDocument *doc)
{
  if (doc== NULL) return;
  this->removeRow(m_manager->documents().indexOf(doc));
  //m_manager->closeDocument(doc);
  //this->removeRow()

}

void DocumentManagerModel::AddDocuments(const QList<IDocument *> &doc)
{
  Q_FOREACH(IDocument *ad, doc)
    AddDocument(ad);
}

void DocumentManagerModel::closeActiveDocument()
{
  if (m_manager->activeDocument() != NULL)
    m_manager->closeDocument(m_manager->activeDocument());
}



int DocumentManagerModel::rowCount(const QModelIndex &parent) const
{
  if (m_manager == NULL || m_manager->documents().count() == 0) return 0;
  if (parent.isValid())
  {
    if (!parent.parent().isValid() )
    return m_manager->documents()[parent.row()]->Channels().count();
    else
      return 0;
  }
  else
    return m_manager->documents().count();

}

QVariant DocumentManagerModel::data(const QModelIndex &index, int role) const
{
  QVariant ret;

  if(!index.isValid()) return ret;

  const QList<IDocument*> docs = m_manager->documents();


  if (docs.count() == 0) return ret;

  if (index.parent().isValid())
  {

    const IDocument *d = docs[index.parent().row()];
    switch (role)
    {

      case Qt::UserRole+1:
		  ret = QVariant();

        break;
      case Qt::DisplayRole:
      case Qt::ToolTipRole:
      case Qt::StatusTipRole:
      case Qt::WhatsThisRole:
		  ret = d->objectName();
        break;
      case Qt::DecorationRole:
		  ret = QIcon();
        break;
      case Qt::EditRole:
      case Qt::SizeHintRole:

      default:
        break;
    }



  }

  else
  {




    switch (role)
    {
      case Qt::UserRole+1:
        ret = QVariant::fromValue(docs[index.row()]);
        break;
      case Qt::DisplayRole:
      case Qt::ToolTipRole:
      case Qt::StatusTipRole:
      case Qt::WhatsThisRole:
        ret = docs[index.row()]->objectName();
        break;

      case Qt::DecorationRole:
        //icono en función del plugin cargado
        break;
      case Qt::EditRole:
      case Qt::SizeHintRole:
		  break;

      default:
        break;
    }
  }
  return ret;

}


QModelIndex DocumentManagerModel::index(int row, int column, const QModelIndex &parent) const
{
  QModelIndex ret;
  if (parent.isValid())
  {
    IDocument* d = parent.data(Qt::UserRole+1).value<IDocument*>();
    ret = createIndex(row,column,d);

  }
  else
  {
    ret = createIndex(row,column);
  }
  return ret;

}

QModelIndex DocumentManagerModel::parent(const QModelIndex &child) const
{
  QModelIndex ret;


  if (child.isValid())
  {
    if (child.internalPointer() != NULL)
    {
      IDocument* d = reinterpret_cast<IDocument*>(child.internalPointer());
      int i = m_manager->documents().indexOf(d);
      if (i >= 0)
        ret = createIndex(i,1);
    }

  }
  return ret;
}

int DocumentManagerModel::columnCount(const QModelIndex &parent) const
{
  return 1;
}


bool DocumentManagerModel::insertRows(int row, int count, const QModelIndex &parent)
{
  beginInsertRows(parent,row,row + count);
  endInsertRows();
  return true;
}

bool DocumentManagerModel::insertColumns(int column, int count, const QModelIndex &parent)
{
  beginInsertColumns(parent,column,column+count);
  endInsertColumns();
  return true;
}

bool DocumentManagerModel::removeRows(int row, int count, const QModelIndex &parent)
{
	if (parent.isValid())
	{
		beginRemoveRows(parent, row, row + count);
		endRemoveRows();
	}
  return true;
}

bool DocumentManagerModel::removeColumns(int column, int count, const QModelIndex &parent)
{
	if (parent.isValid())
	{
		beginRemoveColumns(parent, column, column + count);
		endRemoveColumns();
	}
  return true;
}
