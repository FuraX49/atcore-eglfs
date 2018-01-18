import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../lib"
//import AtCore.Lib 1.0



ListView {
    signal optionchanged(int option)
    id : listRadio
    implicitHeight : 40
    implicitWidth:  100
    highlightResizeDuration: 100
    highlightMoveDuration: 500
    highlightRangeMode: ListView.ApplyRange
    keyNavigationWraps: true
    orientation: ListView.Horizontal
    contentHeight: parent.height - 10
    contentWidth:  parent.width - 10
    model: ["Option 1 ", "Option 2"]
    delegate: RadioDelegate {
        text: modelData
        checked: index == 0
        ButtonGroup.group: buttonGroup
        background: Rectangle {
            implicitWidth: 40
            implicitHeight: 40
            radius: 4
            border.width: 2
        }
    }
    ButtonGroup {
        id: buttonGroup
        onCheckedButtonChanged:
            optionchanged(listRadio.currentIndex);
    }
}


