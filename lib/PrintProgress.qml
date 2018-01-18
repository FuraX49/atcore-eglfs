import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../lib/"

Rectangle {
    id : root
    implicitHeight : 80
    implicitWidth:  200
    radius: 4
    border.width: 2

    property string filename: ""
    property real maxLayers : 1
    property double starttime: 0
    property double  elapsedtime : 0;
    property double  totaltime : 0;
    property alias lbelapsed: lbelapsedtime;
    property alias lbfinish: lbfinishtime;
    property alias lbtotal: lbtotaltime;
    property date dstarttime;


    function percentagePrinted( newProgress) {
       progressBar.value=newProgress;
    }

    function initTime() {
        starttime =  new Date().getTime();
        dstarttime =  new Date();
        progressBar.value=0;
    }

    function updateTime() {
        elapsedtime =  Math.round((new Date().getTime() - starttime )/60000);
        totaltime =  Math.round(elapsedtime/progressBar.position);

        lbelapsed.text = elapsedtime.toLocaleString();
        lbtotal.text = totaltime.toLocaleString();

        dstarttime.setMilliseconds(starttime+(totaltime*60000))
        lbfinish.text = dstarttime.toLocaleTimeString();
    }

    
    ColumnLayout {
        id: columnLayout
        spacing: 2
        anchors.fill: parent
        Label {
            id: filname 
            text: root.filename
            font.bold: true
            font.pixelSize: fontSize10
            verticalAlignment: Text.AlignVCenter
            Layout.maximumHeight: 50
            Layout.minimumHeight: 25
            Layout.preferredHeight: 25
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ProgressBar {
            id: progressBar
            font.pixelSize: fontSize10
            Layout.maximumHeight: 50
            Layout.minimumHeight: 25
            Layout.preferredHeight: 25
            Layout.fillHeight: true
            Layout.fillWidth: true
            value: 0.0
            from : 0
            to : 100
        }

        RowLayout {
            id: rowLayout
            spacing: 2
            Layout.maximumHeight: 50
            Layout.minimumHeight: 25
            Layout.preferredHeight: 25
            Layout.fillHeight: true
            Layout.fillWidth: true
            Label {
                id : lbelapsedtime
                text: qsTr("Passed")
                font.bold: false
                font.pixelSize: fontSize10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                leftPadding: 5
                Layout.maximumHeight: 50
                Layout.minimumHeight: 25
                Layout.preferredHeight: 25
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            Label {
                id : lbfinishtime
                text: qsTr("Finish Time")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.columnSpan: 3
                font.bold: false
                font.pixelSize: fontSize10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                rightPadding: 5
                leftPadding: 5
                Layout.maximumHeight: 50
                Layout.minimumHeight: 25
                Layout.preferredHeight: 25
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            Label {
                id : lbtotaltime
                text: qsTr("Total")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.bold: false
                font.pixelSize: fontSize10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                rightPadding: 5
                Layout.maximumHeight: 50
                Layout.minimumHeight: 25
                Layout.preferredHeight: 25
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }

    }
}
