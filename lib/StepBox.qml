import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


SpinBox {
    id: sbstep
    property string jogsize: items[0]
    anchors.margins: 4
    from: 0
    value: 0
    to:  items.length -1

    property int decimals: 1
    property real realValue: value / 10
    property var items: ["0.1", "0.5", "1","5","10","50"]
    textFromValue: function(value, locale) {
        jogsize=items[value];
        return Number(items[value]).toLocaleString(locale, 'f', sbstep.decimals);
    }


}

