import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2

Item {
    signal cancelled()
    signal next()

    function reset(){

    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 20
        Label{
            Layout.fillWidth: true
            text: "New Participant"
            font.pointSize: fontSize * 1.5
        }

        GridLayout {
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: parent.height / 3.0
            Layout.fillWidth: true
            columns:2
            columnSpacing: 30
            rowSpacing: 10
            Layout.margins: 30
            Layout.bottomMargin: 100

            Label{
                text:"Name:"
                font.pointSize: fontSize
                Layout.alignment: Qt.AlignVCenter

            }

            TextField{
                id:nameInput
                text: "User " + userSettings.numUsers()
                font.pointSize: fontSize
                Layout.fillWidth: true
                Layout.preferredHeight: controlHeight
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                text: "Age Group:"
                font.pointSize: fontSize
                Layout.alignment: Qt.AlignVCenter
            }

            ComboBox{
                id:ageGroupInput
                model: ["0 - 13", "14 - 20", "21 - 30","31 - 40", "41 - 50", "51 - 60","60+"]
                font.pointSize: fontSize
                Layout.fillWidth: true
                Layout.preferredHeight: controlHeight
                popup.font.pointSize: fontSize
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                text: "Gender:"
                font.pointSize: fontSize
                Layout.alignment: Qt.AlignVCenter
            }

            ComboBox{
                id:genderInput
                model: ["Female", "Male", "Other"]
                font.pointSize: fontSize
                Layout.fillWidth: true
                Layout.preferredHeight: controlHeight
                popup.font.pointSize: fontSize
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                text: "Tech Ability:"
                font.pointSize: fontSize
                Layout.alignment: Qt.AlignVCenter
            }

            ComboBox{
                id:techInput
                model: ["Very Little", "Everyday User", "Hacker/Advanced"]
                font.pointSize: fontSize
                Layout.fillWidth: true
                popup.font.pointSize: fontSize
                Layout.preferredHeight: controlHeight
                Layout.alignment: Qt.AlignVCenter
            }
        }

        Rectangle{
            Layout.fillHeight: true
        }

        Row {
            spacing: 16
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredHeight: 100
            Button {
                text: "Cancel"
                font.pointSize: fontSize
                onClicked: cancelled()
                height: controlHeight
                width: controlWidth
            }

            Button {
                text: "Next"
                font.pointSize: fontSize
                height: controlHeight
                width: controlWidth
                onClicked: {
                    currentUser[userSettings._USERNAME] = nameInput.text;
                    currentUser[userSettings._AGE_GROUP] = ageGroupInput.currentText;
                    currentUser[userSettings._GENDER] = genderInput.currentText;
                    currentUser[userSettings._TECH_ABILITY] = techInput.currentText;
                    next();
                }
            }
        }
    }
}
