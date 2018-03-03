import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2
import Qt.labs.settings 1.0
import QtCharts 2.2

Item {
    id:itemRoot
    property var fourWayEase: [0,0,0,0,0,0,0];
    property var fourWayEaseSum : 0
    property var twoWayEase: [0,0,0,0,0,0,0];
    property var twoWayEaseSum: 0
    property var mistakesData: [0,0];
    property real fourWayAvgtime: 0.0;
    property real twoWayAvgtime: 0.0;
    property var fourWayUserMistakes: [];
    property var twoWayUserMistakes: [];

    property int maxContentWidth: 1200;

    property var dataSet : [];

    function setResults(userData){
        dataSet = userData;
        computeEaseOfUse(userData);
        computeTotalMistakes(userData);
        computeAverageTimes(userData);
        computePerUser(userData);
    }

    function computeEaseOfUse(userData){
        var newFourWayEase = [0,0,0,0,0,0,0];
        var newTwoWayEase = [0,0,0,0,0,0,0];
        var newMistakes = [0,0];
        for(var row=0;row<userData.length;row++){
            var user = userData[row];
            var i = user["fourway_ease_of_use"];
            newFourWayEase[i-1]++;
            fourWayEaseSum += i;
            var j = user["twoway_ease_of_use"];
            newTwoWayEase[j-1]++;
            twoWayEaseSum += j;
        }

        //Can't change it directly, need to assign new arrays for items to pick up updates
        fourWayEase = newFourWayEase;
        twoWayEase = newTwoWayEase;

        console.log("result fourway: " + JSON.stringify(fourWayEase));
        console.log("result twoway: " + JSON.stringify(twoWayEase));
    }

    function computeTotalMistakes(userData){
        var newMistakes = [0,0];
        for(var row=0;row<userData.length;row++){
            var user = userData[row];
            var fourResults = user["fourway_results"];
            for(var i=0; i < fourResults.length; i++){
                var result = fourResults[i];
                var val = result["is_success"] ? 0 : 1;
                newMistakes[0] += val;
            }

            var twoResults = user["twoway_results"];
            for(var j=0; j < twoResults.length; j++){
                var result = twoResults[j];
                var val = result["is_success"] ? 0 : 1;
                newMistakes[1] += val;
            }
        }

        //Can't change it directly, need to assign new arrays for items to pick up updates
        mistakesData = newMistakes;
        mistakesSeries.axisY.min = 0;
        mistakesSeries.axisY.max = Math.max(Math.max(mistakesData[0], mistakesData[1]),10);

        console.log("result mistakes data: " + JSON.stringify(mistakesData));
    }

    function computeAverageTimes(userData){
        var fourWayTimes = 0.0;
        var numFourWaySuccess = 0;
        var twoWayTimes = 0.0;
        var numTwoWaySuccess = 0;

        for(var row=0;row<userData.length;row++){
            var user = userData[row];
            var fourResults = user["fourway_results"];
            for(var i=0; i < fourResults.length; i++){
                var result = fourResults[i];
                if(result["is_success"]){
                    fourWayTimes += result["time_ms"];
                    numFourWaySuccess++;
                }
            }

            var twoResults = user["twoway_results"];
            for(var j=0; j < twoResults.length; j++){
                var result = twoResults[j];
                if(result["is_success"]){
                    twoWayTimes += result["time_ms"];
                    numTwoWaySuccess++;
                }
            }
        }

        //Can't change it directly, need to assign new arrays for items to pick up updates
        if(numFourWaySuccess > 0){
            fourWayAvgtime = fourWayTimes / numFourWaySuccess / 1000.0;
        }
        if(numTwoWaySuccess > 0){
            twoWayAvgtime = twoWayTimes / numTwoWaySuccess / 1000.0;
        }
        avgElapsedSeries.axisY.min = 0;
        avgElapsedSeries.axisY.max = Math.max(Math.max(fourWayAvgtime, twoWayAvgtime),10);
    }

    function computePerUser(userData){
        var max = 0;
        var maxTime = 0;
        for(var row=0;row<userData.length;row++){
            var user = userData[row];
            var fourResults = user["fourway_results"];
            var numFourMistakes = 0;
            var timesTotal = 0;
            var numTimes = 0;
            for(var i=0; i < fourResults.length; i++){
                var result = fourResults[i];
                if(!result["is_success"]){
                    numFourMistakes++;
                }else{
                    timesTotal += result["time_ms"];
                    numTimes++;
                }

                if(numFourMistakes > max)
                    max = numFourMistakes;
            }

            var avgElapsedFour =  0;
            if(numTimes != 0){
                avgElapsedFour = timesTotal / numTimes / 1000.0;
            }
            if(avgElapsedFour > maxTime)
                maxTime = avgElapsedFour;

            var twoResults = user["twoway_results"];
            var numTwoMistakes = 0;
            timesTotal = 0;
            numTimes = 0;
            for(var j=0; j < twoResults.length; j++){
                var result = twoResults[j];
                if(!result["is_success"]){
                    numTwoMistakes++;
                }else{
                    timesTotal += result["time_ms"];
                    numTimes++;
                }

                if(numTwoMistakes > max)
                    max = numTwoMistakes;

            }

            var avgElapsedTwo =  0;
            if(numTimes != 0){
                avgElapsedTwo = timesTotal / numTimes / 1000.0;
            }
            if(avgElapsedTwo > maxTime)
                maxTime = avgElapsedTwo;

            var label = user["username"];
            mistakesPerUser.append(label,[numFourMistakes,numTwoMistakes])
            timesPerUser.append(label,[avgElapsedFour,avgElapsedTwo])
        }


        mistakesPerUser.axisX.min = 0;
        mistakesPerUser.axisX.max = Math.max(max,10);
        timesPerUser.axisX.min = 0;
        timesPerUser.axisX.max = Math.max(maxTime,10);
    }

    StackLayout{
        id: stack
        anchors.fill: parent
        anchors.margins: 20
        currentIndex: !dataSet || dataSet.length == 0 ? 0: 1
        Label{
            text: "No Results."
            font.pointSize: fontSize * 2
        }

        ColumnLayout{
            //anchors.fill: parent
            Label{
                Layout.fillWidth: true
                text:"Summary of Results"
                font.pointSize: fontSize * 2
                color: fontColor
                horizontalAlignment: Text.AlignHCenter
                Layout.bottomMargin: 20
            }

            Flickable{
                //Layout.margins: 20
                contentHeight: row1.height + 200
                contentWidth: parent.width

                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
                ColumnLayout {
                    id: row1
                    width: itemRoot.width
                    height: 4000

                    Label{
                        Layout.fillWidth: true
                        text:"Total number of Users: " + dataSet.length
                        wrapMode: Text.WordWrap
                        color: fontColor
                        font.pointSize: fontSize
                    }

                    Label{
                        Layout.fillWidth: true
                        text:"Four Way average success time: " + fourWayAvgtime.toFixed(2) + "s with " + mistakesData[0] + " mistakes."
                        wrapMode: Text.WordWrap
                        color: fontColor
                        font.pointSize: fontSize
                    }

                    Label{
                        Layout.fillWidth: true
                        text:"Two Way average success time: " + twoWayAvgtime.toFixed(2) + "s with " + mistakesData[1] + " mistakes."
                        wrapMode: Text.WordWrap
                        color: fontColor
                        font.pointSize: fontSize
                    }

                    Label{
                        Layout.fillWidth: true
                        text: twoWayEaseSum === fourWayEaseSum ? "Ease of use is tied based on user ratings.": twoWayEaseSum > fourWayEaseSum ? "Two Way was easier to use based on user ratings." : "Four Way was easier to use based on user ratings."
                        wrapMode: Text.WordWrap
                        color: fontColor
                        font.pointSize: fontSize
                    }

                    Label{
                        Layout.fillWidth: true
                        text: "Two Way score: " + twoWayEaseSum +  " vs. Four Way score: " + fourWayEaseSum
                        wrapMode: Text.WordWrap
                        color: fontColor
                        font.pointSize: fontSize
                    }


                    ChartView {
                        id: fourWayEaseOfUseChart
                        title: "Four Way Ease of Use"
                        titleFont: Qt.font({pointSize:fontSize*1.2});
                        legend.alignment: Qt.AlignRight
                        legend.font: Qt.font({pointSize:fontSize*0.8});
                        antialiasing: true
                        Layout.preferredHeight: 600
                        Layout.fillWidth: true

                        PieSeries {
                            id: fourWayPieSeries
                            PieSlice { label: "1 Extremely Difficult"; value: fourWayEase[0] || 0.0 }
                            PieSlice { label: "2"; value: fourWayEase[1] || 0.0  }
                            PieSlice { label: "3"; value: fourWayEase[2] || 0.0 }
                            PieSlice { label: "4 Neutral"; value: fourWayEase[3] || 0.0   }
                            PieSlice { label: "5"; value: fourWayEase[4]  || 0.0 }
                            PieSlice { label: "6"; value: fourWayEase[5]  || 0.0  }
                            PieSlice { label: "7 Effortless"; value: fourWayEase[6] || 0.0 }

                        }
                    }


                    ChartView {
                        id: chart
                        title: "Two Way Ease of Use"
                        titleFont: Qt.font({pointSize:fontSize*1.2});
                        legend.alignment: Qt.AlignRight
                        legend.font: Qt.font({pointSize:fontSize*0.8});
                        antialiasing: true
                        Layout.preferredHeight: 600
                        Layout.fillWidth: true

                        PieSeries {
                            id: twoWayPieSeries
                            PieSlice { label: "1 Extremely Difficult"; value: twoWayEase[0] || 0.0 }
                            PieSlice { label: "2"; value: twoWayEase[1] || 0.0  }
                            PieSlice { label: "3"; value: twoWayEase[2] || 0.0 }
                            PieSlice { label: "4 Neutral"; value: twoWayEase[3] || 0.0  }
                            PieSlice { label: "5"; value: twoWayEase[4] || 0.0 }
                            PieSlice { label: "6"; value: twoWayEase[5]  || 0.0 }
                            PieSlice { label: "7 Effortless"; value: twoWayEase[6]  || 0.0 }
                        }
                    }


                    ChartView {
                        title: "Total User Mistakes (Less is better)"
                        titleFont: Qt.font({pointSize:fontSize*1.2});
                        legend.alignment: Qt.AlignBottom
                        Layout.preferredHeight: 600
                        Layout.fillWidth: true
                        antialiasing: true

                        BarSeries {
                            id: mistakesSeries
                            axisX: BarCategoryAxis {
                                id: mistakesAxisX
                                labelsVisible: false
                            }
                            BarSet { label: "Four Way"; values: [mistakesData[0]] }
                            BarSet { label: "Two Way"; values: [mistakesData[1]] }
                        }
                    }

                    ChartView {
                        title: "Average Success Time in seconds (Less is better)"
                        titleFont: Qt.font({pointSize:fontSize*1.1});
                        legend.alignment: Qt.AlignBottom
                        Layout.preferredHeight: 600
                        Layout.fillWidth: true
                        antialiasing: true

                        BarSeries {
                            id: avgElapsedSeries
                            axisX: BarCategoryAxis {
                                id: elapsedAxisX
                                labelsVisible: false
                            }
                            BarSet { label: "Four Way"; values: [fourWayAvgtime] }
                            BarSet { label: "Two Way"; values: [twoWayAvgtime] }
                        }
                    }

                    ChartView {
                        title: "Mistakes Per User"
                        titleFont: Qt.font({pointSize:fontSize*1.2});
                        legend.alignment: Qt.AlignLeft
                        Layout.preferredHeight: 600
                        Layout.fillWidth: true
                        antialiasing: true

                        HorizontalBarSeries {
                            id: mistakesPerUser
                            axisY: BarCategoryAxis {
                                id: mistakesPerUserAxis
                                labelsVisible: true
                                categories: ["Four Way", "Two Way"]
                            }

                        }
                    }

                    ChartView {
                        title: "Avg. Success Times Per User"
                        titleFont: Qt.font({pointSize:fontSize*1.2});
                        legend.alignment: Qt.AlignLeft
                        Layout.preferredHeight: 600
                        Layout.fillWidth: true
                        antialiasing: true

                        HorizontalBarSeries {
                            id: timesPerUser
                            axisY: BarCategoryAxis {
                                id: timesPerUserAxis
                                labelsVisible: true
                                categories: ["Four Way", "Two Way"]
                            }

                        }
                    }

                    //Strut
                    Rectangle{
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
