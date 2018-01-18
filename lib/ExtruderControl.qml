import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../lib"
//import AtCore.Lib 1.0


Rectangle {
    id: root
    implicitHeight : 180
    implicitWidth:  70
    height: parent.height
    width : parent.width
    radius: 4
    border.width: 2

    signal extrude(string tools,string length)
    signal retract(string tools,string length)

    function majNbToosl(nb) {
        for (var x = 1; x <nb; x++) {
           lmTools.append({"tool":"E"+x.toString()});
        }
    }


    ColumnLayout {
        id: colroot
        anchors.fill: parent
        spacing: 0

        ComboBox {
            id: cbTool
            Layout.maximumHeight: parent.height / 4
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 4
            textRole: "tool"
            model: ListModel {
                id: lmTools
                ListElement { tool: "E0" }
            }
        }

        RoundButton {
            id: roundButton
            text: "+"
            spacing: 0
            padding: 0
            font.weight: Font.ExtraBold
            font.bold: true
            font.pixelSize:  fontSize16
            Layout.maximumHeight: parent.height / 4
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 4
            onClicked: {
                root.extrude(cbTool.currentIndex.toString(),tumbler.model[tumbler.currentIndex].toString())
                // atcore.pushCommand("T"+cbTool.currentIndex.toString());
                //atcore.move(atcore.E,tumbler.model[tumbler.currentIndex] );
            }
        }

        Tumbler {
            id: tumbler
            currentIndex: 0
            wheelEnabled: true
            font.bold: true
            visibleItemCount: 1
            font.weight: Font.Medium
            font.pixelSize:  fontSize12
            wrap: true
            Layout.maximumHeight: parent.height / 4
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: [1, 5,10]
        }

        RoundButton {
            id: roundButton1
            text: "-"
            spacing: 0
            font.weight: Font.ExtraBold
            padding: 0
            font.bold: true
            font.pixelSize: fontSize16
            Layout.maximumHeight: parent.height / 4
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 4
            onClicked: {
                root.retract(cbTool.currentIndex.toString(),tumbler.model[tumbler.currentIndex].toString())
                //atcore.pushCommand("T"+cbTool.currentIndex.toString());
                //atcore.move(atcore.E,-tumbler.model[tumbler.currentIndex] );
            }
        }

    }
}
