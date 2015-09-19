#include "foo.h"

// Qt includes

#include <QCoreApplication>
#include <QDebug>
// STD includes
#include <cstdlib>
#include <iostream>


#include <QtTest>
#include <QtCore>


 #define CTK_TEST_NOOP_MAIN(TestObject) \
int TestObject(int argc, char *argv[]) \
{ \
    QObject tc; \
    return QTest::qExec(&tc, argc, argv); \
}

#if (QT_VERSION < 0x50000 && QT_GUI_LIB) || (QT_VERSION >= 0x50000 && QT_WIDGETS_LIB)

//-----------------------------------------------------------------------------
#define CTK_TEST_MAIN(TestObject) \
  int TestObject(int argc, char *argv[]) \
  { \
    QApplication app(argc, argv); \
    QTEST_DISABLE_KEYPAD_NAVIGATION \
    TestObject##er tc; \
    return QTest::qExec(&tc, argc, argv); \
  }

#else

//-----------------------------------------------------------------------------
#define CTK_TEST_MAIN(TestObject) \
  int TestObject(int argc, char *argv[]) \
  { \
    QCoreApplication app(argc, argv); \
    TestObject##er tc; \
    return QTest::qExec(&tc, argc, argv); \
  }

#endif // QT_GUI_LIB
 

class testfooer: public QObject
{
    Q_OBJECT
private slots:
    void initTestCase();
    void testValidity();
    void testMonth();
};


 void testfooer::initTestCase()
 {
	 ;
 }
void testfooer::testValidity()
{
    // 11 March 1967
    QDate date( 1967, 3, 11 );
    QVERIFY( date.isValid() );
}
 
void testfooer::testMonth()
{
    // 11 March 1967
    QDate date;
    //date.setYMD( 1967, 3, 11 );
    QCOMPARE( date.month(), 0 );
   // QCOMPARE( QDate::longMonthName(date.month()),
   //           QString("March") );
}
 
 
CTK_TEST_MAIN(testfoo)
#include "testfoo.moc"



