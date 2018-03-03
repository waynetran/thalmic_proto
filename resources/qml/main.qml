import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2
import Qt.labs.settings 1.0
import QtSensors 5.0

ApplicationWindow {
    id: appWindow
    visible: true
    height: 800
    width: 480

    property string fontColor : "#566573"
    property int fontSize : 14
    property int controlHeight: 80
    property int controlWidth: 220
    property var currentUser :({})

    function quitToMain(){
        stack.clear();
        stack.push(mainMenuPage);
    }

    Component.onCompleted: {
        console.log("Pixel ratio " + Screen.devicePixelRatio);
        console.log("Pixel density " + Screen.pixelDensity);
        console.log("Resolution: " + Screen.width + "x" + Screen.height);
    }

    Settings {
        id: userSettings
        category: "UserData"
        property var userData:[]
        property string _USERNAME: "username"
        property string _AGE_GROUP: "age_group"
        property string _GENDER: "gender"
        property string _TECH_ABILITY: "tech_ability"

        signal added(var user)
        signal cleared()
        function append(user){
            var list = userData;
            list.push(user);
            //Need to reassign to save the settings
            userData = list;
            added(user);
        }

        function clear(){
            userData = [];
            cleared();
        }

        function numUsers(){
            return userData.length
        }
    }

    TiltSensor {
        id: tiltSensor
        active: true
    }

    header: ToolBar {
        id: toolBar
        height: appWindow.height * .1
        RowLayout {
            anchors.fill: parent
            spacing: 10
            Image {
                source: "qrc:/images/thalmic_logo_mark.svg"
                Layout.maximumHeight: parent.height * .8
                Layout.maximumWidth: Layout.maximumHeight
                //sourceSize.width : Layout.maximumHeight
                //sourceSize.height : Layout.maximumHeight
                Layout.leftMargin: 10
                Layout.alignment: Qt.AlignLeft
                fillMode: Image.PreserveAspectFit
            }

            Label {
                text: "Thalmic Prototype"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                font.pointSize: 20
            }

            ToolButton {
                onClicked: {
                    //mainMenu.open();
                    drawer.open();
                }
                Layout.fillHeight: true
                icon.source : "qrc:/images/menu.svg"
                Layout.maximumHeight: parent.height
                Layout.maximumWidth: Layout.maximumHeight
                Menu{
                    id:mainMenu
                    width: Math.max(Math.min(parent.width,300),200)
                    y:toolBar.height
                    MenuItem{
                        id:mainMenuItem
                        text: "Quit to Main"
                        onTriggered: {
                            quitToMain();
                        }
                    }
                    MenuItem{
                        id:exitItem
                        text: "Exit App"
                        onTriggered: {Qt.quit();}
                    }
                }
            }
        }
    }

    Drawer {
        id: drawer
        width: 0.66 * appWindow.width
        height: appWindow.height
        //y: toolBar.height
        edge: Qt.RightEdge
        //Material.theme: "Dark"
        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            Button {
                text: "Quit to Main"
                font.pointSize: fontSize
                flat: true
                Layout.fillWidth: true
                Layout.preferredHeight: 100

                onClicked:{
                    stack.clear();
                    stack.push(mainMenuPage);
                    drawer.close();
                }
            }
            Button {
                text: "Exit App"
                font.pointSize: fontSize
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                flat: true
                onClicked: {
                    Qt.quit();
                }
            }
            Rectangle{
                Layout.fillHeight: true
            }
        }
    }

    StackView{
        id: stack
        initialItem: mainMenuPage
        anchors.fill: parent

        Component{
            id: mainMenuPage
            MainMenu{
                id:mainPage
                onNewTest: {
                    console.log("new test");
                    stack.push(newUserForm);
                    stack.currentItem.reset();
                }

                onViewResult: {
                    console.log("view result");
                    stack.push(resultsPageComp);
                    stack.currentItem.setResults(userSettings.userData);
                }
            }
        }

        Component{
            id: newUserForm
            ParticipantForm{
                Layout.fillWidth: true
                Layout.fillHeight: true
                onCancelled: {
                    quitToMain();
                }
                onNext: {
                    stack.push(testPageComp);
                    stack.currentItem.reset();
                }
            }
        }

        Component{
            id: testPageComp
            TestMain{
                id: testPage
                onFinished: {
                    userSettings.append(currentUser);
                    quitToMain();
                }
            }
        }

        Component{
            id: resultsPageComp

            ViewResults{
                id: resultsPage
            }
        }

    }
}
