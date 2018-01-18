import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Page {
    id : charttemp
    anchors.fill: parent
    property bool replace :  false
    property int  maxtime:  180
    property int  maxtemp:  300

    function addTemps(sonde,temp,target) {

        switch (sonde ) {
        case 0 : // E0
            graphTemp.addTemp(chart.series(0),0,temp);
            graphTemp.addTemp(chart.series(1),1,target);
            break

        case 1 : // Bed
            graphTemp.addTemp(chart.series(2),2,temp);
            graphTemp.addTemp(chart.series(3),3,target);
            break

        case 2 : // T1
            graphTemp.addTemp(chart.series(4),4,temp);
            graphTemp.addTemp(chart.series(5),5,target);
            break

        case 3 : // T2
            graphTemp.addTemp(chart.series(6),6,temp);
            graphTemp.addTemp(chart.series(7),7,target);
            break

        case 4 : // T3
            graphTemp.addTemp(chart.series(8),8,temp);
            graphTemp.addTemp(chart.series(9),9,target);
            break
        }
    }


    ChartView {
        id : chart
        anchors.margins: 0
        localizeNumbers: true
        visible: true
        enabled: false
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.fillHeight: true
        Layout.fillWidth: true
        anchors.fill: parent
        antialiasing: true
        animationOptions :ChartView.NoAnimation
        legend {
            alignment : Qt.AlignBottom
            showToolTips : true
        }


        ValueAxis{
            id: valueAxisX
            labelsAngle: -90
            min: 0
            max: charttemp.maxtime
            tickCount: 10
            labelFormat: "%.0f"
        }

        ValueAxis{
            id: valueAxisY
            min:0
            max: charttemp.maxtemp
            tickCount: (maxtemp/25)+1
            labelsVisible : true
          }


        LineSeries {
            id: serieExt0
            style : Qt.SolidLine
            name : "E0"
            axisX: valueAxisX
            axisY: valueAxisY
            width : 2

        }

        LineSeries {
            id: serieExt0Target
            style : Qt.DashLine
            name : "E0Target"
            axisX: valueAxisX
            axisY: valueAxisY
        }

    }

    function init(){
        chart.removeAllSeries();
        var seriesE0 = chart.createSeries(ChartView.SeriesTypeLine, "E0", valueAxisX, valueAxisY);
        var seriesE0Target = chart.createSeries(ChartView.SeriesTypeLine, "E0Target", valueAxisX, valueAxisY);
        seriesE0Target.style =  Qt.DashLine
        seriesE0.useOpenGL=false

        if ( appWindow.asbed) {
            var seriesBed = chart.createSeries(ChartView.SeriesTypeLine, "Bed", valueAxisX, valueAxisY);
            var seriesBedTarget = chart.createSeries(ChartView.SeriesTypeLine, "BedTarget", valueAxisX, valueAxisY);
            seriesBedTarget.style=  Qt.DashLine
        }

        if (appWindow.extcount.valueOf()>1) {
            var seriesE1 = chart.createSeries(ChartView.SeriesTypeLine, "E1", valueAxisX, valueAxisY);
            var seriesE1Target = chart.createSeries(ChartView.SeriesTypeLine, "E1Target", valueAxisX, valueAxisY);
            seriesE1Target.style=  Qt.DashLine
        }

        if (appWindow.extcount.valueOf()>2) {
            var seriesE2 = chart.createSeries(ChartView.SeriesTypeLine, "E2", valueAxisX, valueAxisY);
            var seriesE2Target = chart.createSeries(ChartView.SeriesTypeLine, "E2Target", valueAxisX, valueAxisY);
            seriesE2Target.style=  Qt.DashLine
        }

        if (appWindow.extcount.valueOf()>3) {
            var seriesE3 = chart.createSeries(ChartView.SeriesTypeLine, "E3", valueAxisX, valueAxisY);
            var seriesE3Target = chart.createSeries(ChartView.SeriesTypeLine, "E3Target", valueAxisX, valueAxisY);
            seriesE3Target.style=  Qt.DashLine
        }
        graphTemp.initData(chart.count,charttemp.maxtime)
        // TODO update Ext (on/off & T°) on first M105 ?
    }

}


