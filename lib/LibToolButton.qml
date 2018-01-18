import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../lib"
//import AtCore.Lib 1.0


ToolButton {
    property bool border: false
    font.pixelSize: fontSize12
    implicitHeight : 40

    highlighted : true

    implicitWidth:  40

    background: Rectangle {
        implicitWidth: 40
        implicitHeight: 40
        radius: 4
        border.width: 2
    }

}
