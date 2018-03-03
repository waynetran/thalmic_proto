import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2
import Qt.labs.settings 1.0

Item {
    id:itemRoot

    function setResults(userData){
        var text = ""
        for(var i=0;i<userData.length;i++){
            var user = userData[i];
            console.log("result: " + JSON.stringify(user));
            text += "\n " + JSON.stringify(user);
        }

        rawDataLabel.text = JSON.stringify(userData,null, 2);
    }

    ColumnLayout{
        anchors.fill: parent
        Label{
            Layout.fillWidth: true
            text:"Raw User Test Results"
            font.pointSize: fontSize * 2
            color: fontColor
            horizontalAlignment: Text.AlignHCenter
        }

        Flickable{
            Layout.margins: 20
            contentHeight: rawDataLabel.height + 200
            contentWidth: rawDataLabel.width

            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            Text{
                id: rawDataLabel
                color: fontColor
                Layout.fillWidth: true
            }
        }
    }
}
