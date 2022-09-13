import QtQuick
import ScreenLock 1.0

Rectangle {
    id: root
    border.color: "white"
    border.width: showBorder ? 1 : 0
    color: "transparent"
    property string contentType
    property string source
    property real volume
    property bool dummy: false
    property bool autoStart: true
    property int started: 0 // 0: stop, 1: pause, 2: start
    property bool showFrameRate: false
    property bool showBorder: false

    signal initialized
    signal error
    signal videoFramePainted

//    Loader {
//        id: contentLoader
//    }

    VideoItem {
        id: contentLoader
    }

    Connections {
        id: framePaintedConnection
        function onFramePainted() {
            if (frameRateLoader.item)
                frameRateLoader.item.notify()
            root.videoFramePainted()
        }
        ignoreUnknownSignals: true
    }

    Connections {
        id: errorConnection
        function onFatalError() {
            console.log("[qmlvideo] Content.onFatalError")
            stop()
            root.error()
        }
        ignoreUnknownSignals: true
    }

    ScreenLock {
        id: screenLock
    }

    onWidthChanged: {
        if (contentItem())
            contentItem().width = width
    }

    onHeightChanged: {
        if (contentItem())
            contentItem().height = height
    }

    function initialize() {
        if ("video" == contentType) {
//            contentLoader.mediaSource = "VideoItem.qml"
//            if (Loader.Error == contentLoader.status) {
//                contentLoader.source = "VideoDummy.qml"
//                dummy = true
//            }
            contentLoader.volume = volume
        } else if ("camera" == contentType) {
//            contentLoader.mediaSource = "CameraItem.qml"
        } else {
            console.log("[qmlvideo] Content.initialize: error: invalid contentType")
        }
        if (contentLoader) {
            contentLoader.sizeChanged.connect(updateRootSize)
            contentLoader.parent = root
            contentLoader.width = root.width
            framePaintedConnection.target = contentLoader
            errorConnection.target = contentLoader
            if (root.autoStart)
                root.start()
        }
        root.initialized()
    }

    function start() {
        if (contentLoader) {
            if (root.contentType == "video")
                contentLoader.mediaSource = root.source
            contentLoader.start()
            screenLock.keepScreenOn(true)
            root.started = 2
        }
    }

    function pause() {
        if (contentLoader) {
            contentLoader.pause()
            screenLock.keepScreenOn(false)
            root.started = 1
        }
    }

    function stop() {
        if (contentLoader) {
            contentLoader.stop()
            if (root.contentType == "video")
                contentLoader.mediaSource = ""
            root.started = 0
        }
    }

    function contentItem() { return contentLoader }
    function updateRootSize() { root.height = contentItem().height }
}
