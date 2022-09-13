import QtQuick

Rectangle {
    id: root
    color: "black"
    property string source1
    property int contentWidth: parent.width
    property real volume: 0.25
    property int margins: 5
    property QtObject content

    signal close
    signal videoFramePainted
}
