import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2
import Qt.labs.settings 1.0

Page {
    id:itemRoot
    property alias pageIndex: stack.currentIndex
    function setResults(userData){
        summaryPage.setResults(userData);
        rawPage.setResults(userData);
    }

    footer:ToolBar {
        height: controlHeight
        RowLayout{
            anchors.fill: parent

            ToolButton{
                id:summaryButton
                text: "Summary"
                font: Qt.font({pointSize:fontSize});
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: {
                    pageIndex = 0;
                }
                checkable: true
                checked: pageIndex == 0;
                autoExclusive: true
            }
            ToolButton{
                id:rawButton
                text: "Raw Data"
                font: Qt.font({pointSize:fontSize});
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: {
                    pageIndex = 1;
                }
                checkable: true
                checked: pageIndex == 1;
                autoExclusive: true
            }
        }
    }

    StackLayout{
        id: stack
        anchors.fill: parent
        ResultsSummary{
            id: summaryPage
        }

        ResultsRaw{
            id: rawPage
        }
    }
}
