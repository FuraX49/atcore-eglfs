import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


Button {
    id: button
    implicitHeight : 48
    implicitWidth: height
    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    property alias  source : image.source
    text :"ALL"
    padding: 0
    font.bold: true
    Image {
        id: image
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        opacity: 0.3
        height: button.height -4
        width: button.width -4
        source : "qrc:/images/jog/home.png"
    }

    background:  Rectangle {
        radius : parent.width /2
        border.width: 2
        color: button.pressed ? "lightgrey" : "white"
    }
}
