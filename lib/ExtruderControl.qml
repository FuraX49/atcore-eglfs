import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3



Rectangle {
    id: root
    implicitHeight : 180
    implicitWidth:  70
    height: parent.height
    width : parent.width
    radius: 4
    border.width: 2

    property int  tempminimal : 100

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
            id: roundButton1
            text: "\u2191 -"
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
                root.retract(cbTool.currentIndex.toString(),sbLength.items[sbLength.value]);
            }
        }

        SpinBox {
            id : sbLength
            Layout.fillHeight: true
            Layout.fillWidth: true
            font.bold: true
            font.weight: Font.Medium
            font.pixelSize:  fontSize12
            Layout.margins: 4
            from: 0
            value: 1
            to:  items.length -1
            property var items: ["1", "5", "10","25","50"]
            textFromValue: function(value, locale) {
                return Number(items[value]).toLocaleString();
            }

        }

        RoundButton {
            id: roundButton
            text: "\u2193 +"
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
                root.extrude(cbTool.currentIndex.toString(),sbLength.items[sbLength.value]);
            }
        }



    }
}
