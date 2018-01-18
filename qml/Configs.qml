import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.atcore 1.0
import "../lib"

Page {
    id: settingpage
    width: 800
    height: 480
    spacing: 20
    title: qsTr("Setting")

    property int spaces : Math.round(fontSize10 * 0.8)

    ColumnLayout {
        id: columnLayout
        anchors.margins:  spaces *2
        spacing: spaces
        anchors.fill: parent


        RowLayout {
            spacing: spaces

            Label {
                text: qsTr("     Device :")
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                font.pixelSize: fontSize12
                horizontalAlignment: Text.AlignRight
                Layout.fillHeight:  true
            }
            ComboBox {
                id: cbDevice
                font.bold: true
                font.pixelSize: fontSize12
                editable: true
                Layout.fillHeight: false
                Layout.fillWidth: true
                hoverEnabled: true
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.text: "Choose serial device in /dev like ttyACM0"
                ToolTip.visible: hovered
            }


        }

        RowLayout {
            Label {
                text: qsTr("Firmware :")
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                font.pixelSize: fontSize12
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight:  true
            }


            ComboBox {
                id: cbFirmware
                font.bold: true
                font.pixelSize: fontSize12
                editable: true
                Layout.fillHeight: false
                Layout.fillWidth: true
                hoverEnabled: true
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.text: "Leave blank for autodetect"
                ToolTip.visible: hovered
            }
        }

        RowLayout {
            Label {
                text: qsTr("     Speed :")
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                font.pixelSize: fontSize12
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight:  true
            }

            ComboBox {
                id: cbSpeed
                font.bold: true
                font.pixelSize: fontSize12
                Layout.fillHeight: false
                Layout.fillWidth: true
                hoverEnabled: true
                ToolTip.delay: 1000
                ToolTip.timeout: 5000
                ToolTip.text: "Choose serial speed"
                ToolTip.visible: hovered
            }
        }

        RowLayout {
            CheckBox {
                id: cbAsBed
                text: qsTr("Bed Present")
                font.pixelSize: fontSize12
                Layout.fillWidth: true
            }

            Label {
                text: qsTr("Fan :")
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight: false
                font.pixelSize: fontSize12
                font.bold: false
            }

            SpinBox {
                id: sbFanCount
                Layout.fillWidth: true
                font.pixelSize: fontSize12
                font.bold: true
                from: 1
                to: 4
                value: 1
            }

            Label {
                text: qsTr("Ext. :")
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight: false
                font.pixelSize: fontSize12
            }
            SpinBox {
                id: sbExtCount
                Layout.fillWidth: true
                font.pixelSize: fontSize12
                font.bold: true
                from: 1
                to: 4
                value: 1
            }


        }
        RowLayout {
            Label {
                text: qsTr(" PLA T° :")
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: false
                font.pixelSize: fontSize12
            }
            Label {
                text: qsTr("Bed  :")
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight: false
                font.pixelSize: fontSize12
            }

            SpinBox {
                id: sbPlaBed
                Layout.fillWidth: true
                font.pixelSize: fontSize12
                font.bold: true
                from: 0
                to: 120
                value: 60
            }

            Label {
                text: qsTr("Ext :")
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight: false
                font.pixelSize: fontSize12
            }

            SpinBox {
                id: sbPlaExt
                Layout.fillWidth: true
                font.pixelSize: fontSize12
                font.bold: true
                from: 0
                to: 350
                value: 220
            }
        }

        RowLayout {
            Label {
                text: qsTr("ABS T° :")
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight: false
                font.pixelSize: fontSize12
            }
            Label {
                text: qsTr("Bed :")
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight: false
                font.pixelSize: fontSize12
            }

            SpinBox {
                id: sbABSBed
                Layout.fillWidth: true
                 font.pixelSize: fontSize12
                 font.bold: true
                from: 0
                to: 120
                value: 60
            }

            Label {
                text: qsTr("Ext :")
                horizontalAlignment: Text.AlignRight
                Layout.fillWidth: true
                Layout.fillHeight: false
                font.pixelSize: fontSize12
            }

            SpinBox {
                id: sbABSExt
                Layout.fillWidth: true
                 font.pixelSize: fontSize12
                 font.bold: true
                from: 0
                to: 350
                value: 220
            }
        }

        RowLayout {
            TextArea {
                text: qsTr("You must have access in RW on path and file /etc/thing-printer/atcore-eglfs.conf")
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                enabled: false
                font.italic: true
                Layout.fillHeight: true
                Layout.fillWidth: true
                font.pixelSize: fontSize10
            }

            Button {
                id: button
                text: qsTr("Save")
                font.pixelSize: fontSize12
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: {
                    appWindow.acdevice = cbDevice.editText;
                    appWindow.acfirmware =cbFirmware.editText;
                    appWindow.acspeed = cbSpeed.editText;
                    appWindow.asbed = cbAsBed.checked;
                    appWindow.extcount = sbExtCount.value;
                    appWindow.fancount = sbFanCount.value;
                    appWindow.extABS =  sbABSExt.value;
                    appWindow.extPLA =  sbPlaExt.value;
                    appWindow.bedABS =  sbABSBed.value;
                    appWindow.bedPLA =  sbPlaBed.value;
                    appWindow.saveSetting();
                }
            }
        }
    }

    function init(){
        cbDevice.model=atcore.serialPorts;
        if (cbDevice.find(appWindow.acdevice)<0) {
            cbDevice.editText=appWindow.acdevice;
        } else {
            cbDevice.currentIndex=cbDevice.find(appWindow.acdevice.toString()) ;
        }

        cbFirmware.model=atcore.availableFirmwarePlugins;
        if (cbFirmware.find(appWindow.acfirmware)<0) {
            cbFirmware.editText=appWindow.acfirmware
        } else {
            cbFirmware.currentIndex=cbFirmware.find(appWindow.acfirmware) ;
        }


        cbSpeed.model=atcore.portSpeeds;
        if (cbSpeed.find(appWindow.acspeed.toString())<0) {
            cbSpeed.editText=appWindow.acspeed.toString();
        } else {
            cbSpeed.currentIndex=cbSpeed.find(appWindow.acspeed.toString()) ;
        }

        cbAsBed.checked = appWindow.asbed;
        sbExtCount.value=appWindow.extcount
        sbFanCount.value=appWindow.fancount
        sbPlaBed.value = appWindow.bedPLA;
        sbPlaExt.value = appWindow.extPLA;
        sbABSBed.value = appWindow.bedABS;
        sbABSExt.value = appWindow.extABS;
    }


    Component.onCompleted: {
    }
}
