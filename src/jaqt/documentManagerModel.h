#ifndef __DOCUMENTMANAGERMODEL_H__
#define __DOCUMENTMANAGERMODEL_H__


#include <QStandardItemModel>

class IDocument;
class DocumentManager;
class ReaderDocument;


class DocumentManagerModel : public QAbstractItemModel
{
    Q_OBJECT

  public:
    DocumentManagerModel(DocumentManager* manager);


  public slots:
    void AddDocuments(const QList<IDocument*>& doc);
    void AddDocument(IDocument *doc);
    void CloseDocument(IDocument *doc);
    void closeActiveDocument();



  private:
    DocumentManager* m_manager;



    // QAbstractItemModel interface
    //  public:
    //    bool removeRows(int row, int count, const QModelIndex &parent);

    // QAbstractItemModel interface
  public:
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QModelIndex index(int row, int column, const QModelIndex &parent) const;
    QModelIndex parent(const QModelIndex &child) const;
    int columnCount(const QModelIndex &parent) const;

    // QAbstractItemModel interface
  public:
    bool insertRows(int row, int count, const QModelIndex &parent);
    bool insertColumns(int column, int count, const QModelIndex &parent);
    bool removeRows(int row, int count, const QModelIndex &parent);
    bool removeColumns(int column, int count, const QModelIndex &parent);
};



#endif
