import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.folderlistmodel 2.2
import "../lib"
import "../lib/ParseMsg.js" as PM
import "../lib/atcore-share.js" as AS


Page {
    id: files
    width: 800
    height: 480
    title: qsTr("Files")
    anchors.fill: parent
    anchors.margins: 2

    signal fileSelected(string fileName)
    property string fileSelected: ""
    property bool showFocusHighlight: false

    function updateLabelPath(){
        var path = folderModel.folder.toString();
        path = path.replace(/^(file:\/{3})/,"");
        label.text  = "/" + decodeURIComponent(path);
    }

    function currentFolder() {
        return folderModel.folder;
    }

    function isFolder(fileName) {
        return folderModel.isFolder(folderModel.indexOf(folderModel.folder + "/" + fileName));
    }
    function canMoveUp() {
        return folderModel.folder.toString() !== "file:///";
    }

    function onItemClick(fileName) {
        if(!isFolder(fileName)) {
            fileSelected = fileName;
            return;
        }
        if(fileName === ".." && canMoveUp()) {
            folderModel.folder = folderModel.parentFolder
        } else if(fileName !== ".") {
            if(folderModel.folder.toString() === "file:///") {
                folderModel.folder += fileName
            } else {
                folderModel.folder += "/" + fileName
            }
        }

    }


    Component {
        id: highlight
        Rectangle {
            width: fileview.width
            height:  fontSize12 *2
            color: "lightsteelblue"; radius: 5
            y: fileview.currentItem.y
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }



    Component {
        id : colHeader
        Rectangle {
            anchors { left: parent.left; right: parent.right }
            height:  rowheader.implicitHeight * 1.5
            border.width: 2
            radius: 2
            Row  {
                id : rowheader
                anchors { fill: parent; margins: 2 }
                Text {
                    id: name
                    width: parent.width * 0.8
                    font.bold: true
                    font.pixelSize: fontSize12
                    text: qsTr("Name")
                }
                Text {
                    id: size
                    font.bold: true
                    font.pixelSize: fontSize12
                    width: parent.width * 0.2
                    text: qsTr("Size")
                }
            }
        }
    }

    Component {
        id : filesDelegate
        Item {
            id:  wrappper
            anchors { left: parent.left; right: parent.right }
            //height: rowdelegate.implicitHeight + 4
            height : fontSize12 *2

            Row {
                id :rowdelegate
                anchors { fill: parent; margins: 2 }
                Text {
                    id : filename
                    text: fileName
                    font.bold: false
                    font.pixelSize: fontSize12
                    width: parent.width * 0.8
                }
                Text {
                    id : filesize
                    text: Math.round(fileSize/1024) +"Kb"
                    font.bold: false
                    font.pixelSize: fontSize12
                    width: parent.width * 0.2
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked:{
                    wrappper.ListView.view.currentIndex = index;
                    onItemClick(filename.text)
                }
            }
        }
    }

    FolderListModel {
        id: folderModel
        showDotAndDotDot: true
        showDirs: true
        showDirsFirst: true
        folder: pathmodels
        rootFolder: pathmodels
        nameFilters: ["*.gcode", "*.gco","*.stl"]
        onFolderChanged: {
            updateLabelPath();
        }
    }

    ListView {
        id : fileview
        height: 400
        anchors.bottomMargin: 10
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: label.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.margins: 10
        flickableDirection: Flickable.AutoFlickDirection
        highlight: highlight
        highlightFollowsCurrentItem: false
        focus: true
        header: colHeader
        headerPositioning  : ListView.InlineHeader
        model: folderModel
        delegate: filesDelegate

    }
    Label {
        id: label
        height: fontSize14*2
        text: "updateLabelPath"
        font.pixelSize:fontSize14
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom:  parent.bottom
        anchors.margins: 10
    }


    footer:ToolBar {
        id: toolBar
        height:  fontSize12 * 3
        contentHeight: fontSize10 *3
        anchors.margins: 0
        spacing: 0
        padding: 0

        RowLayout {
            id: rowLayout
            spacing: 0
            anchors.fill: parent
            anchors.margins: 0

            HeaderButton {
                id: tbSelect
                text: qsTr("Select")
                autoExclusive: false
                checked: false
                checkable: false
                onClicked: {
                    appWindow.fileSelected(label.text+"/"+fileSelected);
                }
            }


            HeaderButton {
                id: tbLocal
                text: qsTr("Local")
                autoExclusive: true
                checked: true
                checkable: true
                onClicked: {
                    folderModel.folder= pathmodels;
                    folderModel.rootFolder= pathmodels;
                }
            }

            HeaderButton {
                id: tbUsb
                text: qsTr("Usb")
                autoExclusive: true
                checkable: true
                onClicked: {
                    // TOTO shell mount
                    folderModel.folder= "file:///media/usbmem";
                    folderModel.rootFolder= "file:///media/usbmem";
                }
            }
            HeaderButton {
                id: tbSDCard
                text: qsTr("SDCard")
                font.pixelSize: fontSize12
                autoExclusive: true
                checkable: true
                onClicked: {
                    // TOTO shell mount
                    folderModel.folder= "file:///media/sdcard";
                    folderModel.rootFolder= "file:///media/sdcard";
                }
            }

            HeaderButton {
                id: tbRefresh
                text: qsTr("View")
                autoExclusive: false
                checkable: false
                enabled: false
                onClicked: {
                    // TOTO 3d viewer in Popup ?
                    //view3D(fileSelected());
                }
            }
        }
    }


    onVisibleChanged: {
        if (files.visible) {
            //refreshFileList();
        }
    }

    function init(){
        updateLabelPath();
    }
}
