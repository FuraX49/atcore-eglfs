import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../lib"
//import AtCore.Lib 1.0


Rectangle {
    id: root
    radius: 4
    border.width: 2
    implicitHeight: 50
    implicitWidth: 200
    property string title: "Fan"
    property real maxSpeed : 100
    property real minSpeed: 0
    property real currentSpeed: 100
    property real stepsize : 5
    
    signal speedchanged (bool onoff,real  speed)
    
    function majNbFans(nb) {
        for (var x = 1; x <nb; x++) {
           lmFans.append({"fan":"F"+x.toString()});
        }
    }

    GridLayout {
        id: gridLayout
        anchors.fill: parent
        rows: 1
        columns: 6

        Slider {
            id: slider
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            clip: false
            Layout.column : 0
            Layout.row: 0
            Layout.rowSpan: 1
            Layout.columnSpan: 4
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 2
            snapMode: Slider.SnapOnRelease
            orientation: Qt.Horizontal
            value: root.currentSpeed
            from : root.minSpeed
            to   : root.maxSpeed
            stepSize : root.stepsize
            background: Text {
                id: name
                text: slider.value.toString()
                font.weight: Font.Light
                font.pixelSize: fontSize10
                width : parent.width
                height: parent.height
                
            }
            
        }
        
        ComboBox {
            id: cbFans
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumHeight:  parent.height
            Layout.maximumWidth: parent.width / parent.columns
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.weight: Font.Medium
            font.pixelSize: fontSize10
            Layout.row: 0
            Layout.column : 4
            Layout.columnSpan: 1
            Layout.rowSpan: 1
            Layout.margins: 2
            textRole: "fan"
            model: ListModel {
                id: lmFans
                ListElement { fan: "F0" }
            }
        }

        Button {
            id: toolButton
            text: root.title
            Layout.rowSpan: 1
            Layout.row: 0
            Layout.column : 5
            Layout.columnSpan: 1
            Layout.margins: 2
            checkable: true
            checked: false
            font.pixelSize: fontSize12
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumHeight:  parent.height
            Layout.maximumWidth: parent.width / parent.columns
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //iconsource : "qrc:/images/lib/fan_128.png"
            onClicked: {
                atcore.setFanSpeed(slider.value,cbFans.currentIndex);
            }
        }

        
    }
}
