import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ToolButton {
    id: control
    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
    font.weight: Font.ExtraBold
    font.bold: true
    font.pixelSize: fontSize12
    Layout.fillWidth: true
    Layout.fillHeight: true
    background: Rectangle {
        implicitWidth: 40
        implicitHeight: fontSize16
        color: Qt.darker("#33333333", control.enabled && (control.checked || control.highlighted) ? 1.5 : 1.0)
        opacity: enabled ? 1 : 0.3
        visible: control.down || (control.enabled && (control.checked || control.highlighted))
    }

}
