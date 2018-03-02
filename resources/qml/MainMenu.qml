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
                userSettings.clear();
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
}
