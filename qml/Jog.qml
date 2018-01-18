import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.atcore 1.0
import "../lib"

Page {
    id: jog
    width: 600
    height: 400
    title: qsTr("Jog")

    property real  step :  0.01;
    property string frXY : " F"+appWindow.feedRateXY.toString()
    property string frZ : " F"+appWindow.feedRateZ.toString()

    function updatePos(PosAxe) {
        lbpX.text=PosAxe.X.toString();
        lbpY.text=PosAxe.Y.toString();
        lbpZ.text=PosAxe.Z.toString();
    }

    function updateES(EndStop) {
        es_X1.color  = EndStop.X1 ? "white" : "red";
        es_X2.color  = EndStop.X2 ? "white" : "red";
        es_Y1.color  = EndStop.Y1 ? "white" : "red";
        es_Y2.color  = EndStop.Y2 ? "white" : "red";
        es_Z1.color  = EndStop.Z1 ? "white" : "red";
        es_Z2.color  = EndStop.Z2 ? "white" : "red";
    }


    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            if (jog.visible) {
                atcore.pushCommand("M114");
                atcore.pushCommand("M119");
            }
        }
    }


    RowLayout {
        id: rowaxes
        height: fontSize12 * 2
        implicitHeight:  60
        implicitWidth:  400
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: fontSize12
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        spacing : fontSize12

        // Coord
        Label {
            id: lbX
            text: qsTr("X:")
            horizontalAlignment: Text.AlignRight
            font.bold: false
            font.pixelSize: fontSize12
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.column : 0
            Layout.fillHeight: false
            Layout.fillWidth: true
            background: Rectangle {
                id : es_X1
                color: "white"
            }
        }

        Label {
            id: lbpX
            text: "000"
            font.bold: true
            font.pixelSize: fontSize12
            horizontalAlignment: Text.AlignLeft | Qt.AlignVCenter
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.column : 1
            Layout.fillHeight: false
            Layout.fillWidth: true
            background: Rectangle {
                id : es_X2
                color: "white"
            }
        }

        Label {
            id: lbY
            text: qsTr("Y:")
            horizontalAlignment: Text.AlignRight
            font.bold: false
            font.pixelSize: fontSize12
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.column : 2
            Layout.fillHeight: false
            Layout.fillWidth: true
            background: Rectangle {
                id : es_Y1
                color: "white"
            }
        }

        Label {
            id: lbpY
            text: "000"
            horizontalAlignment: Text.AlignLeft | Qt.AlignVCenter
            font.bold: true
            font.pixelSize: fontSize12
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.column : 3
            Layout.fillHeight: false
            Layout.fillWidth: true
            background: Rectangle {
                id : es_Y2
                color: "white"
            }
        }
        Label {
            id: lbZ
            text: qsTr("Z:")
            font.bold: false
            font.pixelSize: fontSize12
            horizontalAlignment: Text.AlignRight
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.column : 4
            Layout.fillHeight: false
            Layout.fillWidth: true
            background: Rectangle {
                id : es_Z1
                color: "white"
            }
        }

        Label {
            id: lbpZ
            text: "000"
            font.bold: true
            font.pixelSize: fontSize12
            Layout.column : 5
            Layout.fillHeight: false
            Layout.fillWidth: true
            background: Rectangle {
                id : es_Z2
                color: "white"
            }
        }
    }

    GridLayout {
        id: gridLayout
        clip: false
        anchors.bottom: rowstep.top
        anchors.margins: fontSize12
        implicitHeight:  360
        implicitWidth:  400
        anchors.top: rowaxes.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        rowSpacing: fontSize12
        columnSpacing: fontSize12
        rows: 3
        columns: 6
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

        // XY
        JogButton {
            id: mY
            text: qsTr("+Y")
            source : "qrc:/images/jog/up.png"
            font.pixelSize: fontSize30
            font.weight: Font.ExtraBold
            autoRepeat: true
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 1
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                // TODO Correct atcore.move with real number !
                //atcore.move(AtCore.Y,jog.step);
                atcore.pushCommand("G1 Y+"+ step.jogsize + frXY );

            }


        }

        JogButton {
            id: mZ
            text: qsTr("+Z")
            source : "qrc:/images/jog/up.png"
            font.pixelSize: fontSize30
            font.weight: Font.ExtraBold
            autoRepeat: true
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 3
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                // atcore.move(AtCore.Z, step.jogsize);
                atcore.pushCommand("G1 Z+"+ step.jogsize + frZ)
            }
        }


        JogButton {
            id: lX
            text: qsTr("-X")
            source : "qrc:/images/jog/left.png"
            font.pixelSize: fontSize30
            font.weight: Font.ExtraBold
            autoRepeat: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            autoExclusive: true
            Layout.column : 0
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                //atcore.move(AtCore.X,-jog.step);
                atcore.pushCommand("G1 X-"+ step.jogsize+ frXY)
            }
        }

        JogButton {
            id: mX
            autoExclusive: true
            text: qsTr("+X")
            source : "qrc:/images/jog/right.png"
            font.pixelSize: fontSize30
            font.weight: Font.ExtraBold
            autoRepeat: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 2
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                //atcore.move(AtCore.X,jog.step);
                atcore.pushCommand("G1 X+"+ step.jogsize + frXY )
            }
        }



        JogButton {
            id: lY
            text: qsTr("-Y")
            source : "qrc:/images/jog/down.png"
            font.pixelSize: fontSize30
            font.weight: Font.ExtraBold
            autoRepeat: true
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 1
            Layout.row : 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                //atcore.move(AtCore.Y,-jog.step);
                atcore.pushCommand("G1 Y-"+ step.jogsize +frXY)
            }
        }

        JogButton {
            id: lZ
            text: qsTr("-Z")
            font.pixelSize: fontSize30
            font.weight: Font.ExtraBold
            source : "qrc:/images/jog/down.png"
            autoRepeat: true
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 3
            Layout.row : 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                //atcore.move(AtCore.Z,-jog.step);
                atcore.pushCommand("G1 Z-"+step.jogsize + frZ)
            }
        }

        // home
        HomeButton {
            id: homeX
            text: "X"
            font.pixelSize: fontSize30
            font.weight: Font.ExtraBold
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 5
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: false
            onClicked: {
                atcore.home(AtCore.X)
            }
        }

        HomeButton {
            id: homeY
            text: "Y"
            font.pixelSize: fontSize30
            font.weight: Font.ExtraBold
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 5
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: false
            onClicked: {
                atcore.home(AtCore.Y)
            }

        }

        HomeButton {
            id: homeall
            text: "ALL"
            font.pixelSize: fontSize24
            font.weight: Font.ExtraBold
            autoExclusive: true
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 5
            Layout.row : 2
            onClicked: {
                atcore.home();
            }
        }

        HomeButton {
            id: homez
            text: "Z"
            font.pixelSize: fontSize30
            font.weight: Font.ExtraBold
            font.wordSpacing: 1
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            autoExclusive: true
            Layout.column : 4
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: false
            onClicked: {
                atcore.home(AtCore.Z)
            }
        }
    }


    RowLayout {
        id: rowstep
        height: fontSize12 * 3
        implicitHeight:  36
        implicitWidth:  400
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: fontSize12
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        spacing: fontSize12

        StepBox {
            id : step
            Layout.columnSpan: 2
            font.pixelSize: fontSize12
            font.bold: true
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        SwapButton {
            textUp : "Absolute"
            textDown : "Relative"
            font.pixelSize: fontSize12
            font.bold: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            onCheckedChanged: {
                if (checked) {
                   atcore.setRelativePosition();
                } else {
                    atcore.setAbsolutePosition();
                }
            }
        }

        SwapButton {
            textUp : "Metric"
            textDown : "Imperial"
            font.pixelSize: fontSize12
            font.bold: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            onCheckedChanged: {
                if (checked) {
                    atcore.setUnits(AtCore.IMPERIAL);
                } else {
                    atcore.setUnits(AtCore.METRIC) ;
                }
            }
        }

        LibToolButton {
            id : tbMotorOff
            text : "Motor OFF"
            Layout.fillHeight: true
            Layout.fillWidth: true
            font.pixelSize: fontSize14
            font.weight: Font.ExtraBold
            onClicked: {
                atcore.setIdleHold(0);
            }
        }

    }

    function init(){
    }

    Component.onCompleted: {
    }

}
