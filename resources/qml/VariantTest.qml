import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2
import "qrc:/js/utils.js" as Utils

Item {
    id: fourWayTest
    property var targets : []
    property int numTrials: 3
    property int numTest: 8
    property var testsTodo : []
    property int currentTest: 0;
    property int currentTrial: 0;
    property string currentTarget: ""
    property var results : []
    //The likert value is from 1 - 7
    property int easeOfUse : -1
    property var startTime: 0
    property var elapsedTimeMS: 0
    property Item navigation: null
    property alias title: titleLabel.text

    signal finished()

    function start() {
        console.log("Starting Variant Test");
        nextTest();
    }

    function reset() {
        resetTest();
        //currentTrial=0;
        currentTrial=3;
        easeOfUse=-1
        results = [];
        resultsDialog.visible = false;
        surveyDialog.visible = false;
    }

    function shuffle(){
        testsTodo = targets.slice();
        Utils.shuffleArray(testsTodo);
    }

    function resetTest(){
        shuffle();
        currentTest=0;
        //currentTest=6;
        currentTarget = testsTodo.pop();
        elapsedTimeMS = 0;
        startTime = 0;
    }

    function nextTrial(){
        currentTrial++;
        if(currentTrial >= numTrials){
            surveyDialog.visible = true;
            return;
        }

        resetTest();
        nextTest();
    }

    function nextTest(){
        if(testsTodo.length === 0 || currentTest >= numTest){
            nextTrial();
            return;
        }
        currentTest++;
        currentTarget = testsTodo.pop();
        startTime = new Date().getTime();
        console.log("Start time: " + startTime);
        navigation.reset();
        navigation.start();
    }

    function newResult(result){
        console.log("new test result: " + result);
        elapsedTimeMS = new Date().getTime() - startTime;
        console.log("End time: " + new Date().getTime());

        if(result === currentTarget){
            resultsDialog.text = "Success!";
            resultsDialog.visible = true;
            saveResult(currentTarget,
                       result,
                       true,
                       elapsedTimeMS);
        }else{
            resultsDialog.text = "Missed!";
            resultsDialog.visible = true;
            saveResult(currentTarget,
                       result,
                       false,
                       elapsedTimeMS);
        }
    }

    function saveResult(target, result, isSuccess, elapsedMS){
        var data = {"target":currentTarget, "result":result,
                      "is_success":isSuccess, "time_ms":elapsedMS};
        results.push(data);
    }

    Component.onCompleted: {
        reset();
    }

    Connections{
        target: navigation

        onFinished: {
            newResult(opt);
        }
    }

    ColumnLayout{
        anchors.fill: parent
        ColumnLayout{
            Layout.margins: 20
            Layout.fillWidth: true
            spacing: 20
            Label{
                id: titleLabel
                Layout.fillWidth: true
                font.pointSize: fontSize * 2
                color: fontColor
                font.bold: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                Layout.leftMargin: 10

            }

            Label{
                text: "Trial : "+ currentTrial +"/"+ numTrials + " test: " + currentTest +"/" + numTest
                font.pointSize: fontSize
                color: fontColor
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }

            ColumnLayout{
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing:20
                Layout.leftMargin: 10
                Layout.topMargin: 30
                Label{
                    text: "Navigate to:"
                    Layout.fillWidth: true
                    font.pointSize: fontSize * 1.2
                    color: fontColor
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
                Label{
                    text: currentTarget
                    Layout.fillWidth: true
                    font.pointSize: fontSize * 1.5
                    font.bold: true
                    color: "steelblue"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        StackView{
            id: stack
            initialItem: navigation
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Item {
        width: resultsDialog.width
        height: resultsDialog.height
        anchors.centerIn: parent
        Dialog {
            id: resultsDialog
            width: fourWayTest.width * .8
            height: 400

            visible: false
            property alias text: resultsLabel.text

            function success(){
                resultsLabel.text = "SUCCESS!";
                resultsLabel.color = "green";
            }

            function fail(){
                resultsLabel.text = "MISSED!"
                resultsLabel.color = "black";
            }

            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 20
                Label{
                    id: resultsLabel
                    Layout.fillWidth: true
                    font.pointSize: fontSize * 2
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    wrapMode: Text.WordWrap
                }

                Label{
                    id: timeLabel
                    text: "Elapsed time: " + elapsedTimeMS +"ms";
                    Layout.fillWidth: true
                    font.pointSize: fontSize
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    wrapMode: Text.WordWrap
                }

                Rectangle{
                    Layout.fillHeight: true
                }

                Button {
                    text: "Next"
                    Layout.preferredHeight: controlHeight
                    Layout.preferredWidth: controlHeight * 2
                    font.pointSize: fontSize
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onClicked: {
                        resultsDialog.accept();
                        nextTest();
                    }
                }
            }
        }
    }

    Item {
        width: surveyDialog.width
        height: surveyDialog.height
        anchors.centerIn: parent
        Dialog {
            id: surveyDialog
            width: fourWayTest.width * .9
            height: fourWayTest.height * .9
            visible: false

            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 20
                Label{
                    id: infoLabel
                    text: "Please rate the overall ease of use with this navigation system."
                    font.pointSize: fontSize * 2
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }

                ColumnLayout{
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    RadioButton {
                        text: qsTr("(1) Extremely difficult")
                        font.pointSize: fontSize
                        onClicked: {easeOfUse=1;}
                    }
                    RadioButton {
                        text: qsTr("(2)")
                        font.pointSize: fontSize
                        onClicked: {easeOfUse=2;}
                    }
                    RadioButton {
                        text: qsTr("(3)")
                        font.pointSize: fontSize
                        onClicked: {easeOfUse=3;}
                    }
                    RadioButton {
                        checked: true
                        text: qsTr("(4) Not difficult but not easy")
                        font.pointSize: fontSize
                        onClicked: {easeOfUse=4;}
                    }
                    RadioButton {
                        text: qsTr("(5)")
                        font.pointSize: fontSize
                        onClicked: {easeOfUse=5;}
                    }
                    RadioButton {
                        text: qsTr("(6)")
                        font.pointSize: fontSize
                        onClicked: {easeOfUse=6}
                    }
                    RadioButton {
                        text: qsTr("(7) Effortless")
                        font.pointSize: fontSize
                        onClicked: {easeOfUse=7;}
                    }

                }

                Button {
                    text: "Next"
                    Layout.preferredHeight: controlHeight
                    Layout.preferredWidth: controlHeight * 2
                    font.pointSize: fontSize
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onClicked: {
                        if(easeOfUse == -1)
                            easeOfUse = 4;

                        surveyDialog.accept();
                        finished();
                    }
                }
            }
        }
    }

}
