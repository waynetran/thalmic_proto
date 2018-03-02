import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2
import "qrc:/js/utils.js" as Utils

Item {
    id: fourWayTest
    property var fourWayTargets : ["Send/Pulse", "Send/Text", "Settings/Do not disturb", "Settings/Sleep",
        "Calendar/Today", "Calendar/Tomorrow", "Health/Pulse", "Health/Calories"
    ]

    property int numTrials: 3
    property int numTest: 8
    property var testsTodo : []
    property int currentTest: 0;
    property int currentTrial: 0;
    property string currentTarget: ""
    property var results : []
    property var startTime: 0
    property var elapsedTimeMS: 0

    signal finished()

    function start() {
        console.log("Starting Fourway Test");
        nextTest();
    }

    function reset() {
        resetTest();
        //currentTrial=0;
        currentTrial=3;
        results = [];
        resultsDialog.visible = false;
    }

    function shuffle(){
        testsTodo = fourWayTargets.slice();
        Utils.shuffleArray(testsTodo);
    }

    function resetTest(){
        shuffle();
        //currentTest=0;
        currentTest=6;
        currentTarget = testsTodo.pop();
        elapsedTimeMS = 0;
        startTime = 0;
    }

    function nextTrial(){
        currentTrial++;
        if(currentTrial >= numTrials){
            finished()
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
        nav1.reset();
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

    ColumnLayout{
        anchors.fill: parent
        ColumnLayout{
            spacing: 10
            Layout.fillWidth: true
            Label{
                text: "Trial : "+ currentTrial +"/"+ numTrials + " test: " + currentTest +"/" + numTest
                Layout.fillWidth: true
                //Layout.preferredHeight: controlHeight
                font.pointSize: fontSize
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.margins: 20
            }

            Label{
                text: "Target: "+currentTarget
                Layout.fillWidth: true
                //Layout.preferredHeight: controlHeight
                font.pointSize: fontSize
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                //Layout.margins: 20
            }
        }

        FourWayNav{
            id:nav1
            Layout.fillHeight: true
            Layout.fillWidth: true
            opt1:"Send"
            opt1Nav: FourWayNav{
                opt1:"Location"
                opt2:"Pulse"
                opt3:"Wave"
                opt4:"Text"
            }
            opt2:"Settings"
            opt2Nav: FourWayNav{
                opt1:"Bluetooth"
                opt2:"GPS"
                opt3:"Do not disturb"
                opt4:"Sleep"
            }
            opt3:"Calendar"
            opt3Nav: FourWayNav{
                opt1:"Today"
                opt2:"Tomorrow"
                opt3:"Add Event"
                opt4:"Cancel Event"
            }
            opt4:"Health"
            opt4Nav: FourWayNav{
                opt1:"Pulse"
                opt2:"O2"
                opt3:"Calories"
                opt4:"Steps"
            }

            onFinished: {
                newResult(opt);
            }
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
                    //Layout.fillWidth: true
                    font.pointSize: fontSize * 2
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    wrapMode: Text.WordWrap
                }

                Label{
                    id: timeLabel
                    text: "Elapsed time: " + elapsedTimeMS +"ms";
                    //Layout.fillWidth: true
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
}
