#include <QtCore/QStandardPaths>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlEngine>
#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickView>
#include "screenlock.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<ScreenLock>("ScreenLock", 1, 0, "ScreenLock");

    QQuickView viewer;
    viewer.setSource(QUrl("qrc:///qml/qmlvideo/main.qml"));
    QObject::connect(viewer.engine(), &QQmlEngine::quit, &viewer, &QQuickView::close);

    QQuickItem *rootObject = viewer.rootObject();

    const QStringList moviesLocation = QStandardPaths::standardLocations(QStandardPaths::MoviesLocation);
    const QUrl videoPath =
            QUrl::fromLocalFile(moviesLocation.isEmpty() ?
                                    app.applicationDirPath() :
                                    moviesLocation.front());
    viewer.rootContext()->setContextProperty("videoPath", videoPath);

    QMetaObject::invokeMethod(rootObject, "init");
    viewer.setMinimumSize(QSize(640, 360));
    viewer.show();

    return app.exec();
}

