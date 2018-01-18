.pragma library

function isOk(msg) {
    var isOk = false;
    var regex = /^ok/i;
    var mreg = new RegExp(regex);
    if (mreg.test(msg)) {
        isOk=true;
    }
    return isOk;
}


// ok T:0.0/0.0 T0:0.0/0.0 T1:0.0/0.0 B:0.0/0.0 @:0.0
var TempHeaters = {
    Bed: 0.0,
    BedTarget : 0.0,
    E0: 0.0,
    E0Target : 0.0,
    E1: 0.0,
    E1Target : 0.0,
    E2: 0.0,
    E2Target : 0.0,
    E3: 0.0,
    E3Target : 0.0
}

function getTemperatures(msg) {
    var isTemp = false;
    var temps = "";
    // search if "T:"  & "B:"
    if (msg.indexOf("T:" ,1)>0) {
        if (msg.indexOf("B:" ,1)>0) {
            var splitmsg = msg.split(" ")
            isTemp = true;
            for (var x = 0; x < splitmsg.length; x++) {
                if (splitmsg[x].startsWith("T:")){
                    temps=splitmsg[x].split("/")
                    TempHeaters.E0=temps[0].slice(2, 10).valueOf();
                    TempHeaters.E0Target=temps[1].valueOf();
                }
                if (splitmsg[x].startsWith("B:")){
                    temps=splitmsg[x].split("/")
                    TempHeaters.Bed=temps[0].slice(2, 10).valueOf();
                    TempHeaters.BedTarget=temps[1].valueOf();
                }
                if (splitmsg[x].startsWith("T1:")){
                    temps=splitmsg[x].split("/")
                    TempHeaters.E1=temps[0].slice(3, 10).valueOf();
                    TempHeaters.E1Target=temps[1].valueOf();
                }
                if (splitmsg[x].startsWith("T2:")){
                    temps=splitmsg[x].split("/")
                    TempHeaters.E2=temps[0].slice(3, 10).valueOf();
                    TempHeaters.E2Target=temps[1].valueOf();
                }
                if (splitmsg[x].startsWith("T3:")){
                    temps=splitmsg[x].split("/")
                    TempHeaters.E3=temps[0].slice(3, 10).valueOf();
                    TempHeaters.E3Target=temps[1].valueOf();
                }
            }
        }
    }
    return isTemp;
}

// ok C: X:0.0 Y:0.0 Z:0.0 E:0.0 A:0.0 B:0.0 C:0.0 H:0.0
var AxesPos = {
    X : 0.0,
    Y : 0.0,
    Z : 0.0,
    E : 0.0
}
function getCoord(msg) {
    var regCoord = "X:([0-9.]+) Y:([0-9.]+) Z:([-0-9.]+) E:([0-9.]+)";
    var isCoord = false;
    var m = msg.match(regCoord) ;
    if (m) {
        if (m.index>1) {
            isCoord = true;
            AxesPos.X=m[1];
            AxesPos.Y=m[2];
            AxesPos.Z=m[3];
            AxesPos.E=m[4];
        }
    }
    return isCoord;
}

// ok X1: False, X2: False, Y1: False, Y2: False, Z1: False, Z2: False
var EndStop = {
    X1 : false,
    X2 : false,
    Y1 : false,
    Y2 : false,
    Z1 : false,
    Z2 : false
}
function getES(msg) {
    var regES = "([X-Z][1-2]:([False|True])){3,6}";
    var  isES = false;
    var  m = msg.match(regES) ;
    if (m) {
        if (m.index>1) {
            isES = true;
            EndStop.X1=m[1];
            EndStop.X2=m[2];
            EndStop.Y1=m[3];
            EndStop.Y2=m[4];
            EndStop.Z1=m[5];
            EndStop.Z2=m[6];
        }
    }
    return isES;
}

var FileList = false;
// Begin file list:
// /lcl/.metadata.yaml 182
// /lcl/treefrog.stl 11810826
// /lcl/calibration-cube.stl 1627
// End file list
function getBeginFile(msg) {
    var  isBF = false;
    if (msg.startsWith("Begin file list",0 ) >0 ) {
        isBF=true;
        FileList=true;
    }
    return isBF;
}


var FileDesc = {
    fileName : "",
    fileSize : ""
}

function getFileDesc(msg) {
    var isFile = false;
    var regex = /^(.+)\s+(\d+)$/;
    var mreg = new RegExp(regex);
    var  m = msg.match(mreg) ;
    if (m) {
        FileDesc.fileName=m[1];
        FileDesc.fileSize=Math.round(m[2]/1024)+" kb";
        isFile = true;
    }
    return isFile;
}



function getEndFile(msg) {
    var  isEF = false;
    if (msg.startsWith("End file list",0 ) >0 ) {
        isEF=true;
        FileList=false;
    }
    return isEF;
}




// match file gcode extension in FileDesc.FileName
function isGcodeFile() {
    var isGCode = false;
    var regex = /\.(gcode|gco)/i;
    var mreg = new RegExp(regex);
    var  m = FileDesc.fileName.match(mreg) ;
    if (m) {
        isGCode=true;
    }
    return isGCode;

}
