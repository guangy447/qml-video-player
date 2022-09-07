#include "screenlock.h"
#include <QDebug>

ScreenLock::ScreenLock(QObject *parent) :  QObject(parent)
{

}

ScreenLock::~ScreenLock()
{

}

void ScreenLock::keepScreenOn(bool keepScreen)
{
    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([keepScreen](){
        QJniObject activity =  QJniObject(QNativeInterface::QAndroidApplication::context());
        if (activity.isValid()) {
            QJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");

            if (window.isValid()) {
                const int FLAG_KEEP_SCREEN_ON = 128;
                if (keepScreen) {
                    window.callMethod<void>("addFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
                } else {
                    window.callMethod<void>("clearFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
                }
            }
        }
    });
}
