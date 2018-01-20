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


function getExtTemp(tool){
    var exttemp = 0;
    switch(tool) {
    case "0":
        exttemp=TempHeaters.E0;
        break;
    case "1":
        exttemp=TempHeaters.E1;
        break;
    case "2":
        exttemp=TempHeaters.E2;
        break;
    case "3":
        exttemp=TempHeaters.E3;
        break;
    default:
        exttemp=0;

    }
   return exttemp;
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
    var isES = false;
    var m = msg.match(/(X1)\s?:\s?(False|True)..?(X2)\s?:\s?(False|True)..?(Y1)\s?:\s?(False|True)..?(Y2)\s?:\s?(False|True)..?(Z1)\s?:\s?(False|True)..?(Z2)\s?:\s?(False|True)/i);
    if (m) {
        if (m.index>1) {
            isES = true;
            EndStop.X1=m[2];
            EndStop.X2=m[4];
            EndStop.Y1=m[6];
            EndStop.Y2=m[8];
            EndStop.Z1=m[10];
            EndStop.Z2=m[12];
        }
    }
    return isES;
}
