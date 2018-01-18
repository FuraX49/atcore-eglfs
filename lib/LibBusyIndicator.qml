import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


BusyIndicator {
    id : libBusyIndicator
    property alias imagesource: image.source
    enabled: false
    running: false
    visible: false
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width /2
    height: parent.height /2
    opacity: 0.6

    function anim(onoff){
        if (onoff) {
            libBusyIndicator.enabled = true;
            libBusyIndicator.visible = true;
            libBusyIndicator.running = true;
        } else {
            libBusyIndicator.enabled = false;
            libBusyIndicator.visible = false;
            libBusyIndicator.running = false;
        }
    }

    background: Image {
        id: image
        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/lib/atcore.png"
    }
}
