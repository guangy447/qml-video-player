TEMPLATE = app
TARGET = qmlvideo

QT += quick multimedia
android: qtHaveModule(androidextras) {
    QT += androidextras
    DEFINES += REQUEST_PERMISSIONS_ON_ANDROID
}

SOURCES += \
    main.cpp \
    screenlock.cpp

resources.files = \
    images/folder.png \
    images/up.png \
    qml/qmlvideo/Button.qml \
    qml/qmlvideo/Content.qml \
    qml/qmlvideo/ErrorDialog.qml \
    qml/qmlvideo/FileBrowser.qml \
    qml/qmlvideo/Scene.qml \
    qml/qmlvideo/SceneDrag.qml \
    qml/qmlvideo/SeekControl.qml \
    qml/qmlvideo/VideoDummy.qml \
    qml/qmlvideo/VideoItem.qml \
    qml/qmlvideo/main.qml

resources.prefix = /

RESOURCES += resources \
    res.qrc

target.path = $$[QT_INSTALL_EXAMPLES]/multimedia/video/qmlvideo
INSTALLS += target

EXAMPLE_FILES += \
    qmlvideo.png \
    qmlvideo.svg

DISTFILES += \
    android-sources/AndroidManifest.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

HEADERS += \
    screenlock.h

