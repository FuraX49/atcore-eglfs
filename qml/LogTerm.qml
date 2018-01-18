import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    id: page
    width: 800
    height: 480

    title: qsTr("Terminal")

    function appmsg(msg) {
        while (logterm.lineCount>120) {
            logterm.remove(0, 80); // Arbitraire !!!
        }
        logterm.append(msg);
    }


    RowLayout {
        id : rowlayouttop
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5
        height : fontSize12 * 2


        TextField {
            id: dataToSend
            Layout.fillHeight: true
            Layout.columnSpan: 4
            font.weight: Font.Bold
            font.bold: false
            font.pixelSize: fontSize10
            Layout.fillWidth: true
            placeholderText:  "Data to send..."

            onEditingFinished: {
                if (atcore.state>1) {
                    atcore.pushCommand(dataToSend.text);
                    logterm.append(dataToSend.text);
                } else {
                    logterm.append("Not connected");
                }
            }
        }



        Button {
            id: sendBtn
            text: qsTr("Send")
            Layout.fillHeight: true
            font.pixelSize: fontSize12
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onClicked: {
                if (atcore.state>1) {
                    atcore.pushCommand(dataToSend.text);
                    logterm.append(dataToSend.text);
                } else {
                    logterm.append("Not connected")
                }
            }
        }


        CheckBox {
            id: cbOkLog
            text: qsTr("Ok")
            Layout.fillWidth: true
            Layout.fillHeight: true
            font.pixelSize: fontSize10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            hoverEnabled: false
            focusPolicy: Qt.ClickFocus
            onCheckedChanged: {
                appWindow.logok = checked;
            }
        }


        CheckBox {
            id: cbTempLog
            text: qsTr("Temp")
            Layout.fillWidth: true
            Layout.fillHeight: true
            font.pixelSize: fontSize10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onCheckedChanged: {
                appWindow.logtemp =   checked;
            }
        }

    }

    ScrollView {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: rowlayouttop.bottom
        anchors.topMargin: 15
        anchors.margins: 5

        TextArea {
            id:  logterm
            cursorVisible: true
            width: parent.width
            height: parent.height
            textFormat : TextEdit.PlainText
            font.pixelSize: fontSize10
            focus: true
            wrapMode: "WrapAtWordBoundaryOrAnywhere"
        }
    }

    function init(){
        cbTempLog.checked=appWindow.logtemp;
        cbOkLog.checked=appWindow.logok;
    }

    Component.onCompleted: {
    }

}
