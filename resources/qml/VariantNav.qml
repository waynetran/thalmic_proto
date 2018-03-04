import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2
import QtSensors 5.0

Item {
    id: fourWayItem

    //Up Menu Item
    property string opt1:""
    property Item opt1Nav: null
    //Left Menu Item
    property string opt2:""
    property Item opt2Nav: null
    //Right Menu Item
    property string opt3:""
    property Item opt3Nav: null
    //Down Menu Item
    property string opt4:""
    property Item opt4Nav: null

    property string pickedText: ""

    property int tiltDelay: 500

    //Tilt sensor XRotation threshold to activate a menu.
    property real xThreshold: 30.0
    //Minimum xRotation distance to add to the ballX
    property real xMin: 20.0

    //Tilt sensor YRotation threshold to activate a menu
    property real yThreshold: 30.0
    //Minimum yRotation distance to add to the ballY
    property real yMin: 20.0

    //factor to move the ball each timestep, ie. ballX += xRotation*accel
    property real accel: 0.1
    property real maxStep: 4

    //tracks the "cursor". 0,0 is the neutral location to start.
    property real ballX:0.0
    property real ballY:0.0


    property bool isFourWay: opt1 && opt2 && opt3 && opt4

    signal picked(string opt)
    signal finished(string opt)

    function reset(){
        if(opt1Nav)
            opt1Nav.reset();
        if(opt2Nav)
            opt2Nav.reset();
        if(opt3Nav)
            opt3Nav.reset();
        if(opt4Nav)
            opt4Nav.reset();
        stack.clear();
        stack.push(mainNav);
        ballX = 0.0;
        ballY = 0.0;
    }


    function start(){
        //console.log("Navigation start.");
        ballX = 0.0;
        ballY = 0.0;
        startTimer.start();
    }

    function stop(){
        //console.log("Navigation stop.");
        tiltTimer.stop();
    }

    function selectUp(){
        select(opt1, opt1Nav);
    }

    function selectLeft(){
        select(opt2, opt2Nav);
    }

    function selectRight(){
        select(opt3, opt3Nav);
    }

    function selectDown(){
        select(opt4, opt4Nav);
    }

    //Private, do not use outside this item
    function select(text,nav){
        //console.log("VariantNav select - " + text);
        stop();
        pickedText = text;
        picked(text);
        if(nav){
            stack.push(nav);
            nav.start();
        }else{
            //console.log("VariantNav - emitting finished: " + text);
            finished(text);
            reset();
        }
    }

    Connections{
        target: opt1Nav
        onFinished:{
            //console.log("finished: " + opt);
            //recursively send back finished with the results separated by "/"
            finished(pickedText + "/" + opt);
        }
        onPicked:{
            picked(opt);
        }
    }

    Connections{
        target: opt2Nav
        onFinished:{
            //console.log("finished: " + opt);
            finished(pickedText + "/" + opt);
        }
        onPicked:{
            picked(opt);
        }
    }

    Connections{
        target: opt3Nav
        onFinished:{
            //console.log("finished: " + opt);
            finished(pickedText + "/" + opt);
        }
        onPicked:{
            picked(opt);
        }
    }

    Connections{
        target: opt4Nav
        onFinished:{
            //console.log("finished: " + opt);
            finished(pickedText + "/" + opt);
        }
        onPicked:{
            picked(opt);
        }
    }

    onPicked: {
        stop();
    }

    Timer {
        id: startTimer
        interval: tiltDelay;  running: false; repeat: false
        onTriggered: {
            if(tiltSensor.active){
                tiltTimer.start();
            }
        }
    }

    Timer {
        id: tiltTimer
        interval: 50; running: false; repeat: true

        onTriggered: {
            if (!tiltSensor.active)
                tiltSensor.active = true;

            var xReading = tiltSensor.reading.xRotation;
            var xStep = xReading * accel;
            if(Math.abs(xReading) > xMin){
                ballX += Math.min(maxStep,xStep);
            }else{
                //We're back in the home zone, reset ballX.
                ballX = 0;
            }

            //console.log("Tilt X: " + xReading + " ballX: " + ballX);

            if(ballX > xThreshold){
                selectDown();
            }else if(ballX < -xThreshold){
                selectUp();
            }

            if(isFourWay){
                var yReading = tiltSensor.reading.yRotation;
                if(Math.abs(yReading) > yMin){
                    var yStep = yReading * accel;
                    ballY += Math.min(maxStep,yStep);
                }else{
                    ballY = 0;
                }

                //console.log("Tilt Y:" + yReading + " ballY: "+ ballY);

                if(ballY > yThreshold){
                    selectRight();
                }else if(ballY < -yThreshold){
                    selectLeft();
                }
            }
        }
    }

    StackView{
        id:stack
        initialItem:mainNav
        anchors.fill: parent
        anchors.margins: 10
    }
    Component{
        id: mainNav
        ColumnLayout{
            function clickUp(){upButton.clicked();}
            function clickDown(){downButton.clicked();}
            function clickLeft(){leftButton.clicked();}
            function clickRight(){rightButton.clicked();}

            Button{
                id: upButton
                text:opt1
                font.pointSize: fontSize
                onClicked:{
                    //Prevent clicking on mobile
                    if(!tiltSensor.active)
                        selectUp();
                }
                Layout.preferredWidth: isFourWay?stack.width/2.0 : stack.width
                Layout.preferredHeight: isFourWay? controlHeight : controlHeight * 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            }
            RowLayout {
                Layout.fillWidth: true
                visible: isFourWay
                Button{
                    id: leftButton
                    text:opt2
                    font.pointSize: fontSize
                    onClicked:{
                        //Prevent clicking on mobile
                        if(!tiltSensor.active)
                            selectLeft();
                    }
                    Layout.preferredWidth: stack.width/2.5
                    Layout.preferredHeight: controlHeight
                    Layout.alignment: Qt.AlignLeft
                }
                Image{
                    Layout.fillWidth: true
                    source: "qrc:/images/compass.svg"
                    Layout.preferredWidth: controlHeight *.5
                    Layout.preferredHeight: controlHeight *.5
                    fillMode: Image.PreserveAspectFit
                }

                Button{
                    id: rightButton
                    text:opt3
                    font.pointSize: fontSize
                    onClicked:{
                        //Prevent clicking on mobile
                        if(!tiltSensor.active)
                            selectRight();
                    }
                    Layout.preferredWidth: stack.width/2.5
                    Layout.preferredHeight: controlHeight
                    Layout.alignment: Qt.AlignRight
                }
            }
            Button{
                id: downButton
                text:opt4
                font.pointSize: fontSize
                onClicked:{
                    //Prevent clicking on mobile
                    if(!tiltSensor.active)
                        selectDown();
                }
                Layout.preferredWidth: isFourWay?stack.width/2.0 : stack.width
                Layout.preferredHeight: isFourWay? controlHeight : controlHeight * 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            }
        }

    }
}
