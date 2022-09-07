This is a video player coded by qt/qml

## technical description

- qt version :
	Qt 6.3.1
- tested on android 7, android 11, windows 10

## requirements

- Loads a video file from File Picker dialog
- Have a play/pause and progress slider
- Slider should also allow user to drag to seek playback position of the video file that’s being played.
- Prevent phone from getting screen auto-locked while the video is playing
- Ability to float and drag the video player within the window

## details
- Implemented all UI components :
	Button, FileBrowser, Slider ...
- Customized ScreenLock component to prevent auto screen-lock on android platform
- Added AndroidManifest.xml file to manage permissions

