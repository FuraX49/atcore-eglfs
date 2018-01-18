import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2
import Qt.labs.settings 1.0
import QtTest 1.0
import org.kde.atcore 1.0
import "../lib/atcore-share.js" as AS
import "../lib/ParseMsg.js" as PM
import "../lib"

Dialog {
    id: popdialog
    x : (parent.width/2) - (width/2)
    y : (parent.height/2) - (height/2)

    background:   Rectangle {
         anchors.fill: parent
        color: "#ff0000"
        radius: 0
        visible: true
        border.color: "black"
        border.width: 4
    }

    function show(titre,message) {
        popdialog.title=titre;
        msg.text=message;
        popdialog.visible = true;
    }

    
    title: "Title"
    visible : false
    Label {
        id : msg
        text: "Lorem ipsum..."
    }
    standardButtons: Dialog.Ok
    onAccepted: {
        popdialog.visible = false;
        popdialog.close();
    }
}
