import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2

Item {
    property alias text: infoLabel.text;
    signal next();

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 20
        Label {
            id: infoLabel
            text: "Press the button to begin the trial."
            font.pointSize: fontSize*2
            elide: Qt.ElideRight
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            //Layout.fillHeight: true
        }

        Button {
            text: "START!"
            font.pointSize: fontSize*3
            onClicked: next()
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

    }
}
