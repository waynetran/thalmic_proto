import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQml 2.2

Item {

    property int numVariant: 1
    property int numDone: 0
    property int currentVariant: 0

    signal finished()

    function nextVariant(){
        if(numDone >= numVariant){
            finished()
        }
    }

    function reset(){
        stackLayout.currentIndex = 0;
        fourWay.reset();
        currentVariant = 0;
        numDone = 0;
    }

    StackLayout{
        id: stackLayout
        anchors.fill: parent
        ParticipantForm{
            Layout.fillWidth: true
            Layout.fillHeight: true
            onCancelled: {
                quitToMain();
            }
            onNext: {
                stackLayout.currentIndex++;
            }
        }

        ReadySetGo{
            id: trialPrep
            onNext: {
                stackLayout.currentIndex++;
                fourWay.start();
            }
        }

        FourWayTest{
            id:fourWay
            onFinished: {
                numDone++;
                currentUser["fourway_results"] = fourWay.results
                nextVariant();
            }
        }
    }
}
