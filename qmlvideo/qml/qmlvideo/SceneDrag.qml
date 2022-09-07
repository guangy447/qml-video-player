import QtQuick

Scene {
    id: sceneRoot
    property int margin: 20
    property string contentType

    Rectangle {
        id: background
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Content {
            id: content
            anchors.centerIn: parent
            width: sceneRoot.contentWidth
            contentType: sceneRoot.contentType
            source: sceneRoot.source1
            volume: sceneRoot.volume
            onVideoFramePainted: sceneRoot.videoFramePainted()
        }
    }

    MouseArea {
        anchors.fill: parent
        drag.target: background
    }

    function start() {
        content.start()
    }

    function stop() {
        content.stop()
    }

    function pause() {
        content.pause()
    }

    function isStarted() {
        return content.started
    }

    Component.onCompleted: sceneRoot.content = content
}
