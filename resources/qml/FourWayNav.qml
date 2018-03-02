import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2

Item {
    id: fourWayItem
    property string opt1:""
    property Item opt1Nav: null
    property string opt2:""
    property Item opt2Nav: null
    property string opt3:""
    property Item opt3Nav: null
    property string opt4:""
    property Item opt4Nav: null
    property string pickedText: ""

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
    }

    Connections{
        target: opt1Nav
        onFinished:{
            console.log("finished: " + opt);
            finished(pickedText + "/" + opt);
        }
    }

    Connections{
        target: opt2Nav
        onFinished:{
            console.log("finished: " + opt);
            finished(pickedText + "/" + opt);
        }
    }

    Connections{
        target: opt3Nav
        onFinished:{
            console.log("finished: " + opt);
            finished(pickedText + "/" + opt);
        }
    }

    Connections{
        target: opt4Nav
        onFinished:{
            console.log("finished: " + opt);
            finished(pickedText + "/" + opt);
        }
    }

    onPicked: {
        pickedText = opt
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
            Button{
                text:opt1
                font.pointSize: fontSize
                onClicked:{
                    picked(text);
                    if(opt1Nav){
                        stack.push(opt1Nav);
                    }else{
                        finished(text);
                        reset();
                    }
                }
                Layout.preferredWidth: fourWayItem.width/2.0
                Layout.preferredHeight: controlHeight
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            }
            RowLayout {
                Layout.fillWidth: true
                Button{
                    text:opt2
                    font.pointSize: fontSize
                    onClicked:{
                        picked(text);
                        if(opt2Nav){
                            stack.push(opt2Nav);
                        }else{
                            finished(text);
                            reset();
                        }
                    }
                    Layout.preferredWidth: fourWayItem.width/2.5
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
                    text:opt3
                    font.pointSize: fontSize
                    onClicked:{
                        picked(text);
                        if(opt3Nav){
                            stack.push(opt3Nav);
                        }else{
                            finished(text);
                            reset();
                        }
                    }
                    Layout.preferredWidth: fourWayItem.width/2.5
                    Layout.preferredHeight: controlHeight
                    Layout.alignment: Qt.AlignRight
                }
            }
            Button{
                text:opt4
                font.pointSize: fontSize
                onClicked:{
                    picked(text);
                    if(opt4Nav){
                        stack.push(opt4Nav);
                    }else{
                        finished(text);
                        reset();
                    }
                }
                Layout.preferredWidth: fourWayItem.width/2.0
                Layout.preferredHeight: controlHeight
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            }
        }
    }
}
