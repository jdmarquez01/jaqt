#ifndef DOCUMENT_H
#define DOCUMENT_H

#include <QObject>
class QAbstractItemModel;
class QStandardItemModel;

class tsk_ChannelInfo;
class tsk_ImageData;
class abstractVisitor;

class IDocument : public QObject// tu solo debes de trabajar con modelos...
{
  Q_OBJECT

  public:
    virtual ~IDocument(){}

 //   //tsk_DataFile *m_iface;
 //   //QList<QGraphicsScene*> m_scenes;

 //   virtual QAbstractItemModel *debug() = 0;
 //   QAbstractItemModel *imagesModel;
 //   virtual QStandardItemModel *channelModel() = 0;


	virtual const QList<int> Channels() { return QList<int>(); }
 //   virtual const QList<tsk_ImageData*> Images() const = 0;
 //   virtual tsk_ChannelInfo *activeChannel() const = 0;


 //   virtual bool canAddChannel() = 0;
 //   virtual bool canRemoveChannel() = 0;

 //   virtual void Accept(abstractVisitor &) = 0;
	//
	//virtual QAbstractItemModel* model() = 0;


 // public slots:
 //   virtual void setActiveChannel(tsk_ChannelInfo*) = 0;


 //  signals:
 //   void activeChannelChanged(tsk_ChannelInfo*);
 //   void channelAdded(tsk_ChannelInfo*);
 //   void channelRemoved(tsk_ChannelInfo*);


};

#define MyInterface_iid "com.acme.MyInterface"

//Q_DECLARE_INTERFACE(IDocument, MyInterface_iid)

#endif // DOCUMENT_H
