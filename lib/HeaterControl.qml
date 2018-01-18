import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "../lib/"

Rectangle {
    id: root
    implicitHeight : 180
    implicitWidth:  70
    height: parent.height
    width : parent.width
    radius: 4
    border.width: 2

    property string title: "Ext 0"
    property real maxTemp : 300
    property real minTemp: 0
    property real optimalTemp: 200
    property real currentTemp: optimalTemp
    property real stepsize : 5

    signal heatchanged (bool heat,real  temperature)
    signal tempchanged (real  temperature)

    function heatAt( onoff, temperature) {
        btnOnOff.checked = onoff;
        currentTemp=temperature;
    }
    function heatOff( onoff) {
        btnOnOff.checked = onoff;
    }


    function emitTempChanged(){
        if (btnOnOff.checked)
            tempchanged (root.currentTemp)
    }


    ColumnLayout {
        id: colroot
        anchors.fill: parent
        spacing: 0
        Label {
            id: titre
            text: root.title
            Layout.fillHeight: true
            Layout.maximumHeight: parent.height / 5
            Layout.fillWidth: true
            Layout.margins:  4
            font.bold: false
            font.pixelSize: fontSize10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        RoundButton {
            id: more
            text: "+"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            hoverEnabled: true
            font.bold: true
            font.pixelSize: fontSize12
            wheelEnabled: false
            autoRepeat: true
            Layout.margins:  4
            Layout.maximumHeight: parent.height / 5
            Layout.preferredWidth: parent.width *0.8
            Layout.preferredHeight: more.width *0.5
            Layout.minimumHeight: 20
            onReleased: {
                if ( pressed )  {
                    if (currentTemp+stepsize<maxTemp){
                        currentTemp+=stepsize;
                    } else {
                        currentTemp=maxTemp;
                    }
                } else {
                    if (currentTemp<maxTemp){
                        currentTemp++;
                    }
                }
                emitTempChanged();
            }
        }

        TextField {
            id: tF_Value
            //padding:  root.border.width
            inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator {bottom: root.minTemp; top: root.maxTemp;}
            maximumLength: root.maxTemp.toString().length
            text: root.currentTemp.toString()
            placeholderText: root.currentTemp.toString()
            font.bold: true
            font.pixelSize: fontSize12
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: parent.height / 5
            Layout.margins:  4
            padding: 0
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            background: Rectangle {
                      color:  "transparent"
                      border.color: "transparent"
                  }
            onEditingFinished: {
                if (acceptableInput) root.currentTemp=text.valueOf();
                emitTempChanged();
            }
        }

        RoundButton {
            id: less
            text: "-"
            font.bold: true
            font.pixelSize: fontSize12
            wheelEnabled: true
            autoRepeat: true
            focusPolicy: Qt.StrongFocus
            highlighted: false
            Layout.margins:  4
            Layout.preferredWidth: parent.width *0.8
            Layout.preferredHeight: less.width*0.5
            Layout.maximumHeight: parent.height / 5
            Layout.minimumHeight: 20
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onReleased: {
                if ( pressed ) {
                    if (currentTemp+stepsize>minTemp) {
                        currentTemp-=stepsize;
                    } else {
                        currentTemp=minTemp;
                    }
                } else {
                    if (currentTemp>minTemp) {
                        currentTemp--;
                    }
                }
                emitTempChanged();
            }
        }

        Button {
            id: btnOnOff
            text: qsTr("ON")
            font.pixelSize: fontSize12
            Layout.minimumHeight: 25
            Layout.preferredHeight: 30
            Layout.maximumHeight: parent.height / 5
            Layout.fillHeight: true
            Layout.fillWidth: true
            hoverEnabled: false
            checked: false
            checkable: true
            Layout.margins:  4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onCheckedChanged: {
                if (checked==true) {
                    text = qsTr("Off")
                    root.heatchanged (true,root.currentTemp)
                }   else {
                    text = qsTr("On")
                    root.heatchanged (false,root.currentTemp)

                }
            }
        }
    }
}
