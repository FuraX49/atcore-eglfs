import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.2
import Qt.labs.settings 1.0
import QtQml 2.2
import QtTest 1.0
import org.kde.atcore 1.0
import "../lib/atcore-share.js" as AS
import "../lib/ParseMsg.js" as PM
import "../lib"

Page {
    id: appWindow
    visible: true
    width: 800
    height: 480
    title: qsTr("AtCore-EGLFS")
    /*
    SystemPalette { id: myPalette; colorGroup: SystemPalette.Active }
    Material.theme: Material.Dark
    Material.accent: Material.Purple
*/
    property string filetoprint : ""
    // Base on Minimal Height of 480
    property int fontSize10 : Math.round(height / 48 );
    property int fontSize12 : Math.round(height / 40 );
    property int fontSize14 : Math.round(height / 34 );
    property int fontSize16 : Math.round(height / 30 );
    property int fontSize20 : Math.round(height / 24 );
    property int fontSize24 : Math.round(height / 20 );
    property int fontSize30 : Math.round(height / 16 );


    //  Q_LOGGING_CATEGORY(ATCORE_EGLFS, "thing-printer.atcore-eglfs");
    Item {
        LoggingCategory {
            id: category
            name: "thing-printer.atcore-eglfs"
        }

    }

    // ************ SETTINGS ***************************************
    property string acdevice : ""
    property string acfirmware :  ""
    property string acspeed :  "115200"
    property bool  logok :  false
    property bool  logtemp:  false
    property bool  asbed :  true
    property int  extcount :  1
    property int  fancount :  1
    property int  extABS :  220
    property int  extPLA :  180
    property int  bedABS :  70
    property int  bedPLA :  50
    property int  feedRateXY :  2000
    property int  feedRateZ :  1000
    property int  feedRateE :  200
    property string  pathmodels :  "file:///usr/share/models"



    function saveSetting() {
        settings.device =appWindow.acdevice ;
        settings.firmware  =appWindow.acfirmware ;
        settings.speed  =appWindow.acspeed ;
        settings.asbed =appWindow.asbed ;
        settings.extcount =appWindow.extcount;
        settings.fancount =appWindow.fancount;
        settings.extabs =appWindow.extABS ;
        settings.extpla =appWindow.extPLA ;
        settings.bedabs =appWindow.bedABS;
        settings.bedpla =appWindow.bedPLA;
        settings.logok = appWindow.logok;
        settings.logtemp = appWindow.logtemp;
        settings.feedRateXY =  appWindow.feedRateXY
        settings.feedRateZ =  appWindow.feedRateZ
        settings.feedRateE =  appWindow.feedRateE
        settings.pathmodels =  appWindow.pathmodels
    }

    Settings {
        id: settings
        category : "Printer"

        property alias device: appWindow.acdevice
        property alias firmware: appWindow.acfirmware
        property alias speed: appWindow.acspeed
        property alias logok: appWindow.logok
        property alias logtemp: appWindow.logtemp
        property alias asbed: appWindow.asbed
        property alias extcount: appWindow.extcount
        property alias fancount: appWindow.fancount
        property alias extabs : appWindow.extABS
        property alias extpla : appWindow.extPLA
        property alias bedabs : appWindow.bedABS
        property alias bedpla : appWindow.bedPLA
        property alias feedRateXY :  appWindow.feedRateXY
        property alias feedRateZ :  appWindow.feedRateZ
        property alias feedRateE :  appWindow.feedRateE
        property alias pathmodels: appWindow.pathmodels

        Component.onDestruction:  saveSetting();
    }



    Settings {
        id: theme
        category : "Theme"
        property alias width: appWindow.width
        property alias height: appWindow.height
        /*        property alias theme: Material.theme
        property alias accent :material.accent
        property alias primary :material.primary
        property alias foreground : material.foreground
        property alias background  : material.background
*/
    }

    PopDialog {
        id: popdialog
    }



    SignalSpy {
        function raz() {
            spyAtCore.clear();
            spyAtCore.target= atcore;
            spyAtCore.signalName= "stateChanged";
            return valid;
        }
        id: spyAtCore
        target: atcore
        signalName: "stateChanged"
    }

    Timer {
        id : timerProgress
        interval : 60000
        repeat : true
        running : false
        triggeredOnStart : true
        onTriggered: {
            printpage.printprogress.updateTime() ;        }
    }

    AtCore {
        id: atcore

        onReceivedMessage: {
            addlog(message);
        }

        onStateChanged: {
            switch(state) {
            case  AtCore.DISCONNECTED :
                console.log(category,"atcore DISCONNECTED ");
                break;

            case  AtCore.CONNECTING :
                console.log(category,"atcore  CONNECTING");
                break;

            case  AtCore.IDLE :
                console.log(category,"atcore  IDLE");
                break;

            case  AtCore.BUSY :
                console.log(category,"atcore  BUSY");
                break;

            case AtCore.PAUSE :
                console.log(category,"atcore  PAUSE");
                tbPrint.enabled=false;
                tbPause.enabled=true;
                tbStop.enabled=true;
                timerProgress.stop();
                break;

            case AtCore.ERRORSTATE :
                console.log(category,"atcore  ERRORSTATE");
                break;

            case AtCore.STOP :
                console.log(category,"atcore  STOP");
                tbPrint.enabled=true;
                tbPause.enabled=false;
                tbStop.enabled=false;
                timerProgress.stop();
                break;

            case AtCore.STARTPRINT :
                console.log(category,"atcore  STARTPRINT");
                tbPrint.enabled=false;
                tbPause.enabled=true;
                tbStop.enabled=true;
                printpage.printprogress.initTime();
                timerProgress.start();


                break;

            case AtCore.FINISHEDPRINT :
                console.log(category,"atcore  FINISHEDPRINT");
                tbPrint.enabled=true;
                tbPause.enabled=false;
                tbStop.enabled=false;
                timerProgress.stop();
                break;

            default:
                break;
            }

        }

        onPrintProgressChanged: {
            printpage.printprogress.percentagePrinted(newProgress);

        }

        Component.onCompleted: {
            console.log(category,"main.qml onCompleted")
        }

    }

    function addlog( msg) {
        try {
            var smsg=msg.toString();
            //  console.log(smsg);

            if (PM.getTemperatures(smsg)) {
                tempchart.addTemps(0,PM.TempHeaters.E0,PM.TempHeaters.E0Target);
                if (asbed) tempchart.addTemps(1,PM.TempHeaters.Bed,PM.TempHeaters.BedTarget);
                if (extcount>1) tempchart.addTemps(2,PM.TempHeaters.E1,PM.TempHeaters.E1Target);
                if (extcount>2) tempchart.addTemps(3,PM.TempHeaters.E2,PM.TempHeaters.E2Target);
                if (extcount>3) tempchart.addTemps(4,PM.TempHeaters.E3,PM.TempHeaters.E3Target);
                if (logtemp) {
                    terminal.appmsg(smsg);
                }
                return true;
            }

            if (PM.getCoord(smsg)) {
                jog.updatePos(PM.AxesPos);
                return true;
            }
            /* TODO RegExp pour EndStop
            if (PM.getES(msg)) {
                jog.updateES(PM.EndStop);
            }*/

            if (PM.FileList) {
                if (PM.getEndFile(smsg))  {
                    busy.anim(false);
                    return true;
                } else {
                    if (PM.getFileDesc(smsg)) {
                        if (PM.isGcodeFile()) {
                            files.addFileDesc(PM.FileDesc);
                        }
                        return true;
                    }
                }
            }

            if (PM.getBeginFile(smsg)) {
                busy.anim(true);
                files.clearFileList();
                return true;
            }

            if (PM.isOk(smsg)) {
                if (logok) {
                    terminal.appmsg(smsg);
                }
                return true;
            }
            terminal.appmsg(smsg);

        }
        catch (e) {
            console.log(category,"catch exception on :" + smsg)
        }

        finally {

        }
    }

    function fileSelected (fileName){
        if (atcore.state<AtCore.BUSY) {
            printpage.printprogress.filename=fileName;
            filetoprint=fileName;
            tbPrint.enabled =true;
        }
    }

    header: ToolBar {
        id: headtoolbar

        height:  fontSize16 * 2
        contentHeight: fontSize16 *2
        anchors.margins: 0
        spacing: 0
        padding: 0

        RowLayout {
            spacing: 0
            anchors.fill: parent
            anchors.margins: 0
            HeaderButton {
                id : tbMenu
                text: "\u2630 Menu"
                font.pixelSize: fontSize16
                onClicked: {
                    drawer.open();
                }
            }


            HeaderButton {
                id: tbPrint
                text: qsTr("Print")
                font.pixelSize: fontSize16
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                enabled: false
                onClicked: {
                    if (filetoprint!="") {
                        atcore.print(filetoprint);

                    }
                }
            }

            HeaderButton {
                id: tbPause
                text: qsTr("Pause")
                font.pixelSize: fontSize16
                checkable: true
                enabled: false
                onClicked: {
                    if (checked) {
                        // ask PAUSE
                        text = "Resume";
                        atcore.pause();

                    } else {
                        // ask RESUME
                        text = "Pause";
                        atcore.resume();
                    }
                }
            }


            HeaderButton {
                id: tbStop
                text: qsTr("Stop")
                font.pixelSize: fontSize16
                enabled: false
                onClicked: {
                    atcore.stop();
                }
            }

            HeaderButton {
                id: tbEmergency
                text: qsTr("Emergency")
                font.pixelSize: fontSize16
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                onClicked: {
                    atcore.pushCommand("M112");
                }
            }
        }

    }

    Drawer {
        id: drawer
        y : headtoolbar.height
        x:0
        ColumnLayout {
            spacing: 0
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Print")
                Layout.fillWidth: true
                spacing: 5
                font.bold: true
                font.pixelSize: fontSize14
                width: parent.width
                onClicked: {
                    stackView.currentIndex=0
                    drawer.close()
                }
            }

            ItemDelegate {
                text: qsTr("Log")
                spacing: 5
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: fontSize14
                width: parent.width
                onClicked: {
                    stackView.currentIndex = 1
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Chart")
                spacing: 5
                Layout.fillWidth: true
                font.pixelSize: fontSize14
                font.bold: true
                width: parent.width
                onClicked: {
                    stackView.currentIndex = 2
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Files")
                spacing: 5
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: fontSize14
                width: parent.width
                onClicked: {
                    stackView.currentIndex = 3
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Jog")
                spacing: 5
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: fontSize14
                width: parent.width
                onClicked: {
                    stackView.currentIndex = 4
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Setting")
                spacing: 5
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: fontSize14
                width: parent.width
                onClicked: {
                    stackView.currentIndex = 5
                    drawer.close()
                }
            }
        }
    }

    StackLayout {
        id:stackView
        anchors.fill: parent
        currentIndex: 0
        Print {id : printpage}
        LogTerm {id : terminal}
        ChartTemperatures{ id : tempchart}
        Files {id : files  }
        Jog {id : jog}
        Configs {id : configs}
    }

    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: appWindow.height
        width: appWindow.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: appWindow.height - inputPanel.height -tbMenu.implicitHeight
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }


    function init(){
        busy.anim(true);
        try {
            if (acdevice==="" ) {
                popdialog.show("Configuration Error","You must define acdevice in  /etc/thing-printer/atcore-eglfs.conf")
            }
            if (acspeed==="" ) {
                popdialog.show("Configuration Error","You must define acspeed in  /etc/thing-printer/atcore-eglfs.conf")
            }
            if (atcore.initSerial(acdevice,acspeed.valueOf()) ) {
                spyAtCore.wait(5000);
                if(atcore.state === AtCore.CONNECTING) {
                    if (acfirmware!="") {
                        atcore.loadFirmwarePlugin(acfirmware);
                    } else {
                        atcore.detectFirmware();
                    }

                    // TODO test bool firmwarePluginLoaded()
                    addlog("ArCore Version :" + atcore.version);
                    spyAtCore.wait(10000);
                    if (spyAtCore.count<2) {
                        popdialog.show("Configuration Error","Time init device too long, review  /etc/thing-printer/atcore-eglfs.conf")
                    }
                } else {
                    popdialog.show("Configuration Error","Time connecting  too long, review  /etc/thing-printer/atcore-eglfs.conf")
                }
            } else {
                popdialog.show("Configuration Error","Unable to init serial device , review  /etc/thing-printer/atcore-eglfs.conf")
            }

        }
        catch (E) {
            popdialog.show("Error","Error during initialisation, review configuration file?")
        }
        printpage.init();
        terminal.init();
        tempchart.init();
        files.init();
        jog.init();
        configs.init();
        if (atcore.state===AtCore.IDLE) {
            atcore.pushCommand("M110");
        }

        busy.anim(false);
    }

    // Must be the last for stay visible...
    LibBusyIndicator {
        id : busy
    }

    // run Animation after all component ready
    Timer {
        id : animstart
        repeat : false
        interval : 250
        running : false
        triggeredOnStart : true
        onTriggered: {
            if (running) {
                appWindow.init();
            }
        }
    }

    Component.onCompleted: {
        animstart.start();
    }


    Component.onDestruction: {
        // files.unMountDevice();
        atcore.closeConnection();
        atcore.setState(AtCore.DISCONNECTED);
    }

}
