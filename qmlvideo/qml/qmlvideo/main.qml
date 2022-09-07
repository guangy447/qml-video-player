import QtQuick

Rectangle {
    id: root
    anchors.fill: parent
    color: "black"

    property string source1
    property color bgColor: "black"
    property real volume: 0.25
    property bool perfMonitorsLogging: false
    property bool perfMonitorsVisible: false

    QtObject {
        id: d
        property int itemHeight: root.height > root.width ? root.width / 10 : root.height / 10
        property int buttonHeight: 0.8 * itemHeight
        property int margins: 5
    }

    Loader {
        id: performanceLoader

        Connections {
            target: inner
            function onVisibleChanged() {
                if (performanceLoader.item)
                    performanceLoader.item.enabled = !inner.visible
            }
            ignoreUnknownSignals: true
        }

        function init() {
            var enabled = root.perfMonitorsLogging || root.perfMonitorsVisible
            source = enabled ? "../performancemonitor/PerformanceItem.qml" : ""
        }

        onLoaded: {
            item.parent = root
            item.anchors.fill = root
            item.logging = root.perfMonitorsLogging
            item.displayed = root.perfMonitorsVisible
            item.enabled = false
            item.init()
        }
    }

    onSource1Changed: {
        sceneDrag.source1 = root.source1;
        sceneDrag.content.initialize();
    }

    Rectangle {
        id: inner
        anchors.fill: parent
        color: root.bgColor

        Button {
            id: openFile1Button
            anchors {
                top: parent.top
                left: parent.left
                right: exitButton.left
                margins: d.margins
            }
            bgColor: "#212121"
            bgColorSelected: "#757575"
            textColorSelected: "white"
            height: d.buttonHeight
            text: (root.source1 == "") ? "Select file 1" : root.source1
            onClicked: fileBrowser1.show()
        }

        Button {
            id: exitButton
            anchors {
                top: parent.top
                right: parent.right
                margins: d.margins
            }
            bgColor: "#212121"
            bgColorSelected: "#757575"
            textColorSelected: "white"
            width: parent.width / 10
            height: d.buttonHeight
            text: "Exit"
            onClicked: Qt.quit()
        }

        SceneDrag {
            id: sceneDrag
            anchors {
                top: exitButton.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            contentType: "video"
            width: parent.width
            height: parent.height - exitButton.height
            clip: true
            source1: root.source1
        }

        Button {
            id: startButton
            anchors {
                bottom: parent.bottom
                left: parent.left
                margins: 10
            }
            bgColor: "#212121"
            bgColorSelected: "#757575"
            textColorSelected: "white"
            width: parent.width / 10
            height: Math.min(parent.width, parent.height) / 20
            text:  sceneDrag.isStarted() === 2 ? "Pause" : "Play"
            onClicked: {
                if(sceneDrag.isStarted() === 2)
                {
                    sceneDrag.pause()
                }
                else
                {
                    sceneDrag.start()
                }
            }
        }

        SeekControl {
            anchors {
                bottom: parent.bottom
                left: startButton.right
                right: parent.right
                margins: 10
            }
            duration: sceneDrag.content.contentItem() ? sceneDrag.content.contentItem().duration : 0
            playPosition: sceneDrag.content.contentItem() ? sceneDrag.content.contentItem().position : 0
            onSeekPositionChanged: sceneDrag.content.contentItem().seek(seekPosition);
        }
    }

    Loader {
        id: sceneLoader
    }

    Connections {
        id: videoFramePaintedConnection
        function onVideoFramePainted() {
            if (performanceLoader.item)
                performanceLoader.item.videoFramePainted()
        }
        ignoreUnknownSignals: true
    }

    FileBrowser {
        id: fileBrowser1
        anchors.fill: root
        onFolderChanged: fileBrowser2.folder = folder
        Component.onCompleted: fileSelected.connect(root.openFile1)
    }

    FileBrowser {
        id: fileBrowser2
        anchors.fill: root
        onFolderChanged: fileBrowser1.folder = folder
//        Component.onCompleted: fileSelected.connect(root.openFile2)
    }

    function openFile1(path) {
        root.source1 = path
    }

    ErrorDialog {
        id: errorDialog
        anchors.fill: root
        dialogWidth: d.itemHeight * 5
        dialogHeight: d.itemHeight * 3
        enabled: false
    }

    // Called from main() once root properties have been set
    function init() {
        performanceLoader.init()
        fileBrowser1.folder = videoPath
        fileBrowser2.folder = videoPath
    }

    function qmlFramePainted() {
        if (performanceLoader.item)
            performanceLoader.item.qmlFramePainted()
    }

    function closeScene() {
        sceneSelectionPanel.sceneSource = ""
    }
}
