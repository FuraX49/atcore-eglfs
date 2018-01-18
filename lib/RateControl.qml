import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../lib"
//import AtCore.Lib 1.0


Rectangle {
    id: root
    implicitHeight: 50
    implicitWidth: 150
    radius: 4
    border.width: 2
    property string title: "Rate"
    property real maxRate : 300
    property real minRate: 0
    property real currentRate: 100
    property real stepsize : 5

    signal ratechanged (real  speed)


    GridLayout {
        id: gridLayout
        anchors.fill: parent
        rows: 1
        columns: 4
        Slider {
            id: slider
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            clip: false
            Layout.column : 0
            Layout.row: 0
            Layout.rowSpan: 1
            Layout.columnSpan: 3
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 2
            snapMode: Slider.SnapOnRelease
            orientation: Qt.Horizontal
            value: root.currentRate
            from : root.minRate
            to   : root.maxRate
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



        Button {
            id: toolButton
            text: root.title
            Layout.rowSpan: 1
            Layout.row: 0
            Layout.column : 4
            Layout.columnSpan: 1
            Layout.margins: 2
            font.pixelSize: fontSize10
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            //iconsource : "qrc:/images/lib/fan_128.png"
            onClicked: {
                ratechanged(slider.value);
            }
        }


    }
}
