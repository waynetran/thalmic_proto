import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2

Item {
    id: rootItem
    property int buttonHeight: appWindow.contentItem.height / 5.0
    signal newTest()
    signal viewResult()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30
        anchors.centerIn: parent
        Rectangle{
            color: "transparent"
            Layout.fillHeight: true
        }

        Button {
            id: newTestButton
            text: "New Test Participant"
            font.pointSize: fontSize
            Layout.fillWidth: true
            Layout.preferredHeight: buttonHeight
            onClicked: {
                newTest();
            }
        }

        Button {
            id: resultsButton
            text: "View Results (" + userSettings.userData.length + ")"
            font.pointSize: fontSize
            Layout.fillWidth: true
            Layout.preferredHeight: buttonHeight
            onClicked: {
                viewResult();
            }

            Connections{
                target: userSettings
                onAdded: {
                    console.log("onAdded: " + JSON.stringify(user));
                }
            }
        }

        Button {
            id: clearResultsButton
            text: "Clear Results"
            font.pointSize: fontSize
            Layout.fillWidth: true
            Layout.preferredHeight: buttonHeight
            onClicked: {
                confirmEraseDialog.open();
            }
        }

        Button {
            id: exitButton
            text: "Exit"
            font.pointSize: fontSize
            Layout.fillWidth: true
            Layout.preferredHeight: buttonHeight
            onClicked: {
                Qt.quit();
            }
        }
        Rectangle{
            color: "transparent"
            Layout.fillHeight: true
        }
    }

    Item {
        width: confirmEraseDialog.width
        height: confirmEraseDialog.height
        anchors.centerIn: parent
        Dialog{
            id: confirmEraseDialog
            width: rootItem.width * .8
            height: rootItem.height * .8
            //standardButtons: Dialog.Ok | Dialog.Cancel
            Text{
                anchors.fill: parent
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Are you sure you want to erase all user test data?"
                wrapMode: Text.WordWrap
                font.pointSize: fontSize*1.5
            }

            footer: RowLayout {
                Button {
                    Layout.fillWidth: true
                    Layout.margins: 20
                    text: qsTr("Ok")
                    DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
                    Layout.preferredHeight: controlHeight * 1.5
                    Layout.preferredWidth: controlWidth * 2
                    font.pointSize: fontSize
                    onClicked: {confirmEraseDialog.accept();}
                }
                Button {
                    Layout.fillWidth: true
                    Layout.margins: 20
                    text: qsTr("Cancel")
                    DialogButtonBox.buttonRole: DialogButtonBox.DestructiveRole
                    Layout.preferredHeight: controlHeight * 1.5
                    Layout.preferredWidth: controlWidth * 2
                    font.pointSize: fontSize
                    onClicked: {confirmEraseDialog.reject();}
                }
            }

            onAccepted: {userSettings.clear();}
            onRejected: {}
        }
    }
}
