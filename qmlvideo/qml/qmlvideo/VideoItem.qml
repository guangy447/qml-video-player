import QtQuick
import QtMultimedia

VideoOutput {
    id: root
    height: width

    property alias duration: mediaPlayer.duration
    property alias mediaSource: mediaPlayer.source
    property alias metaData: mediaPlayer.metaData
    property alias playbackRate: mediaPlayer.playbackRate
    property alias position: mediaPlayer.position
    property alias seekable: mediaPlayer.seekable
    property alias volume: audioOutput.volume

    signal sizeChanged
    signal fatalError

    onHeightChanged: root.sizeChanged()

    MediaPlayer {
        id: mediaPlayer
        videoOutput: root;
        audioOutput: AudioOutput {
            id: audioOutput
        }

        onErrorOccurred: function(error, errorString) {
            if (MediaPlayer.NoError !== error) {
                console.log("[qmlvideo] VideoItem.onError error " + error + " errorString " + errorString)
                root.fatalError()
            }
        }
    }

    function start() { mediaPlayer.play() }
    function stop() { mediaPlayer.stop() }
    function pause() { mediaPlayer.pause() }
    function seek(position) { mediaPlayer.setPosition(position); }
}
