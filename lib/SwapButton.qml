import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ToolButton {

    property string  textUp : "Up"
    property string  textDown : "Down"

    id: control
    implicitWidth: 40
    implicitHeight: 40
    checkable: true
    highlighted : true
    text: checked ?  textUp : textDown

    contentItem: Item {
        id: item1
        Text {
            text: control.textUp
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 0
            font: control.font
            opacity: control.checked ? 0.3 : 1
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            text: control.textDown
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin:0
            font: control.font
            opacity: control.checked ? 1 : 0.3
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        width : control.width
        height: control.height
        radius: 4
        border.width: 2
    }


}
