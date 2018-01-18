import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.atcore 1.0
import "../lib"
import "../lib/atcore-share.js" as AS


Page {
    id: printpage
    width: 800
    height: 480
    title: qsTr("Print")

    property string frE : " F"+appWindow.feedRateE.toString()
    property alias printprogress : printProgress

    function allHeatExt(onOff,typeheat){
        var newTemp
        if (onOff) {
            if (typeheat === AS.heattype.abs) {
                if (heatBed.visible) heatBed.heatAt(onOff,bedABS);
                if (heatE0.visible) heatE0.heatAt(onOff,extABS);
                if (heatE1.visible) heatE1.heatAt(onOff,extABS);
                if (heatE2.visible) heatE2.heatAt(onOff,extABS);
                if (heatE3.visible) heatE3.heatAt(onOff,extABS);
            } else {
                if (heatBed.visible) heatBed.heatAt(onOff,bedPLA);
                if (heatE0.visible) heatE0.heatAt(onOff,extPLA);
                if (heatE1.visible) heatE1.heatAt(onOff,extPLA);
                if (heatE2.visible) heatE2.heatAt(onOff,extPLA);
                if (heatE3.visible) heatE3.heatAt(onOff,extPLA);
            }
        }  else {
            if (heatBed.visible) heatBed.heatOff(false);
            if (heatE0.visible) heatE0.heatOff(false);
            if (heatE1.visible) heatE1.heatOff(false);
            if (heatE2.visible) heatE2.heatOff(false);
            if (heatE3.visible) heatE3.heatOff(false);
        }
    }


    GridLayout {
        id: gridLayout
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: 10
        height: parent.height /2
        rows: 3
        columns: 8
        rowSpacing: 10
        columnSpacing: 10

        PrintProgress {
            id: printProgress
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.row : 0
            Layout.column : 0
            Layout.rowSpan: 2
            Layout.columnSpan: 4
        }



        RateControl {
            id: rcSpeed
            Layout.fillHeight: true
            Layout.fillWidth: true
            title: "Speed"
            Layout.row : 0
            Layout.rowSpan: 1
            Layout.column : 4
            Layout.columnSpan: 3
            minRate: 50
            maxRate: 200
            currentRate : 100
            onRatechanged: {
                atcore.setPrinterSpeed(speed);
            }
        }

        RateControl {
            id: rcFlow
            Layout.fillHeight: true
            Layout.fillWidth: true
            title: "Flow"
            Layout.row : 1
            Layout.rowSpan: 1
            Layout.column : 4
            Layout.columnSpan: 3
            minRate: 10
            maxRate: 300
            currentRate : 100
            onRatechanged: {
                atcore.setFlowRate(speed);
            }
        }

        LibToolButton {
            id: btnABS
            text: qsTr("ABS")
            Layout.fillHeight: true
            Layout.fillWidth: true
            autoExclusive: false
            checkable: true
            Layout.row : 0
            Layout.rowSpan: 1
            Layout.column : 7
            Layout.columnSpan: 1
            onClicked: {
                if ( btnPLA.checked ) btnPLA.checked = false;
                if (checked) {
                    allHeatExt(true,AS.heattype.abs)
                } else {
                    allHeatExt(false,AS.heattype.abs)
                }
            }
        }

        LibToolButton {
            id: btnPLA
            text: qsTr("PLA")
            Layout.fillHeight: true
            Layout.fillWidth: true
            autoExclusive: false
            checkable: true
            Layout.row : 1
            Layout.rowSpan: 1
            Layout.column : 7
            Layout.columnSpan: 1
            onClicked: {
                if ( btnABS.checked ) btnABS.checked = false;
                if (checked) {
                    allHeatExt(true,AS.heattype.pla)
                } else {
                    allHeatExt(false,AS.heattype.pla)
                }
            }
        }


        LibToolButton {
            id : tbMotorOff
            text : "Motor OFF"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.row : 2
            Layout.rowSpan: 1
            Layout.column : 0
            Layout.columnSpan: 1
            font.pixelSize: fontSize14
            font.weight: Font.ExtraBold
            onClicked: {
                atcore.setIdleHold(0);
                addlog("M84");
            }
        }



        FanControl {
            id: fan
            Layout.fillHeight: true
            Layout.fillWidth: true
            title: "Fans"
            Layout.row : 2
            Layout.rowSpan: 1
            Layout.column : 4
            Layout.columnSpan: 4
        }

        
    }

    RowLayout {
        id: rowLayout
        anchors.bottom: parent.bottom
        anchors.top: gridLayout.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins:  10
        spacing: 10
        HeaterControl {
            id : heatBed
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible : true
            title: "Bed"
            maxTemp : 120
            optimalTemp: 60
            onHeatchanged: {
                if (heat) {
                    atcore.setBedTemp(temperature,false);
                } else {
                    atcore.setBedTemp(0,false);
                }
            }
            onTempchanged: {
                atcore.setBedTemp(temperature,false);
            }

        }

        HeaterControl {
            id : heatE0
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible : true
            title: "Ext 0"
            maxTemp : 300
            optimalTemp: 200
            onHeatchanged: {
                if (heat) {
                    atcore.setExtruderTemp(temperature,0,false);
                } else {
                    atcore.setExtruderTemp(0,0,false);
                }
            }
            onTempchanged: {
                atcore.setExtruderTemp(temperature,0,false);
            }
        }

        HeaterControl {
            id : heatE1
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible : true
            title: "Ext 1"
            maxTemp : 300
            optimalTemp: 200
            onHeatchanged: {
                if (heat) {
                    atcore.setExtruderTemp(temperature,1,false);
                } else {
                    atcore.setExtruderTemp(0,1,false);
                }
            }
            onTempchanged: {
                atcore.setExtruderTemp(temperature,1,false);
            }
        }

        HeaterControl {
            id : heatE2
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible : true
            title: "Ext 2"
            maxTemp : 300
            optimalTemp: 200
            onHeatchanged: {
                if (heat) {
                    atcore.setExtruderTemp(temperature,2,false);
                } else {
                    atcore.setExtruderTemp(0,2,false);
                }
            }
            onTempchanged: {
                atcore.setExtruderTemp(temperature,2,false);
            }
        }
        HeaterControl {
            id : heatE3
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible : true
            title: "Ext 3"
            maxTemp : 300
            optimalTemp: 200
            onHeatchanged: {
                if (heat) {
                    atcore.setExtruderTemp(temperature,3,false);
                } else {
                    atcore.setExtruderTemp(0,3,false);
                }
            }
            onTempchanged: {
                atcore.setExtruderTemp(temperature,3,false);
            }
        }

        ExtruderControl {
            id: ext
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onExtrude: {
                atcore.pushCommand("T"+tools);
                atcore.pushCommand("G1 E+"+ length +frE)
            }
            onRetract: {
                atcore.pushCommand("T"+tools);
                atcore.pushCommand("G1 E-"+ length +frE)
            }
        }
    }
    
     function init(){
         if (appWindow.asbed )     {heatBed.visible=true; } else {heatBed.visible=false;}
         if (appWindow.extcount>1 ) {heatE1.visible=true; } else {heatE1.visible=false; }
         if (appWindow.extcount>2 ) {heatE2.visible=true; } else {heatE2.visible=false; }
         if (appWindow.extcount>3 ) {heatE3.visible=true; } else {heatE3.visible=false; }
         ext.majNbToosl(appWindow.extcount);
         fan.majNbFans(appWindow.fancount);
         // TODO update Ext (on/off & T°) on first M105 ?
      }

    Component.onCompleted: {


    }
}
