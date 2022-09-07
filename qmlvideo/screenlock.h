#ifndef SCREENLOCK_H
#define SCREENLOCK_H

#include <QJniObject>
#include <qnativeinterface.h>
#include <QCoreApplication>

class ScreenLock : public QObject
{
    Q_OBJECT
public:
    ScreenLock(QObject* parent = nullptr);
    ~ScreenLock();

public slots:
    Q_INVOKABLE void keepScreenOn(bool keepScreen);
};

#endif // SCREENLOCK_H
